#!/bin/bash
echo "Installing HTACCESS and GOACCESS"

usage() {
  echo "nginxLogs.sh [www_root_folder]";
  echo "for example, /var/www/dcdocs.app is where the report.html file will go";
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

echo "Creating root folder at /var/www/$rootFolder"
sudo mkdir "/var/www/$rootFolder";

echo "Configuring goaccess configuration at /etc/goaccess.conf"

# Configuring goaccesss config file for Nginx
sudo sed -i 's/#time-format %H:%M:%S/time-format %H:%M:%S/' /etc/goaccess.conf
sudo sed -i 's;#date-format %d/%b/%Y;date-format %d/%b/%Y;' /etc/goaccess.conf
sudo sed -i 's/#log-format COMBINED/log-format COMBINED/' /etc/goaccess.conf
sudo sed -i 's/#html-report-title My Awesome Web Stats/html-report-title Stats/' /etc/goaccess.conf
sudo sed -i 's;#log-file /var/log/apache2/access.log;log-file /var/log/nginx/access.log;' /etc/goaccess.conf
sudo sed -i "s;#output-format /path/file.html;/var/www/$rootFolder/gopanel/"

echo "Installing htaccess and adding 'admin' role"
sudo apt install apache2-utils -y

# Prompt user for admin password to get access to /logs route
sudo mkdir /etc/nginx/apache2;
sudo htpasswd -c /etc/nginx/apache2/.htpasswd admin 

echo "1) Create an 'A Record' pointing to goaccess.THE_URL.app subdomain"
echo "2) Expand the letsencyrpt signature to include the new subdomain (letsencrypt --expand)"
echo "3) Follow the instructions in this blog to create a new Nginx Server bloc, and systemd configuration to run goaccess (https://bytes.fyi/real-time-goaccess-reports-with-nginx/)"
echo "4) Note, the systemd file needs to be modified, to point correctly at goaccess, report.html, and nginx logs"
echo "4) Make sure the new server block has the LetsEncrypt records"
echo "5) Configure htaccess for the new nginx server, w/ htaccess file located at /etc/nginx/apache2/.htpasswd (https://www.digitalocean.com/community/tutorials/how-to-set-up-password-authentication-with-nginx-on-ubuntu-14-04)"
