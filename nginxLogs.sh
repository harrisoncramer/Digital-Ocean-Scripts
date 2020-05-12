#!/bin/bash

usage() {
  echo "nginxLogs.sh [root_of_nginx_project]";
  echo "for example, /sites/demo";
}

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

if [[ "$#" -eq 0 ]]; then
  usage
  exit 1;
fi

rootFolder="$1";

# goaccess must be installed!!
isGoaccessInstalled=$(dpkg-query -l goaccess | grep 'log analyzer and interactive viewer' | wc -l)
if [[ "$isGoaccessInstalled" -eq "0" ]]; then
  echo "goaccess must be installed, installing now..."
  sudo apt install goaccess -y
fi

# Checking installation
isGoaccessInstalledNow=$(dpkg-query -l goaccess | grep 'log analyzer and interactive viewer' | wc -l)
if [[ "$isGoaccessInstalledNow" -eq "0" ]]; then
  echo "goaccess could not be installed!!"
  exit 1;
fi

# Create goaccess.sh script and make executable
echo "Creating goaccessScript.sh at /etc/nginx/goaccessScript.sh";
goaccessScript='/etc/nginx/goaccessScript.sh';
sudo touch "$goaccessScript";
sudo chmod +x "$goaccessScript";

# Write script
sudo echo '#!/bin/bash' >> "$goaccessScript";
sudo echo "sudo goaccess /var/log/nginx/access.log -o "${rootFolder}/report.html" --log-format=COMBINED --real-time-html" >> "$goaccessScript";

# Adding systemd log script
echo "Creating goaccess.service at /etc/systemd/system/goaccess.service";
serviceFile='/etc/systemd/system/goaccess.service';

# Create our .service file
sudo touch "$serviceFile";

sudo cat <<EOF >> "$serviceFile"
[Unit]
Description=Goaccess Logs
After=network.target

[Service]
Type=simple 
User=root 
Group=root 
Restart=always 
EOF

sudo echo "ExecStart=${goaccessScript}" >> "$serviceFile";

sudo cat <<EOF >> "$serviceFile"
StandardOutput=null 
StandardError=null 
[Install]
WantedBy=multi-user.target
EOF

# Make service file executable 
sudo chmod +x "$serviceFile";

# Start service
sudo systemctl enable "$serviceFile";
sudo systemctl start goaccess

if [[ $? -ne 0 ]]; then
  echo "Could not start goaccess.service";
  exit 1;
fi

echo "Configuring password protection for /logs route"
sudo apt install apache2-utils -y

# Prompt user for admin password to get access to /logs route
sudo mkdir /etc/nginx/apache2;
sudo htpasswd -c /etc/nginx/apache2/.htpasswd admin 

# Point Nginx at our report.html file (this is built off the root of our folder)
NGINX_CONFIGURATION=$(cat <<'EOF'
    
    root DIRECTORY_WHERE_YOU_SAVED_REPORT.HTML # The compiled server directory

    location = /report.html {
      try_files $uri $uri/=404;
      auth_basic "Admin Area Only";
      auth_basic_user_file  "/etc/nginx/apache2/.htpasswd";
    }
EOF
);

echo "Point your Nginx server at the new report.html file located in ${rootFolder}";
echo "$NGINX_CONFIGURATION";
