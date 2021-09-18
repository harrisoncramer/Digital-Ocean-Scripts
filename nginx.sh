#!/bin/bash
usage(){
    echo "${0} IP_ADDRESS DOMAIN PORT";
    exit 1
};

# Modify and replace placeholders in my_server file.
IP_ADDRESS="${1}"
DOMAIN="${2}"
PORT="${3}"

if [[ $((PORT)) != $PORT ]]; then
    echo "Port is not a number."
    usage
fi

if [[ ! $IP_ADDRESS =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]
then
    echo "IP Address is not valid."
    usage
fi

echo "Configuring Nginx..."
sudo apt-get update -qq
sudo apt-get install nginx --yes

echo "Adding Nginx configuration file"
sudo rm /etc/nginx/nginx.conf
sudo mv ./reference/nginx.conf /etc/nginx/nginx.conf

if [[ $? -ne 0 ]]
then
    echo "Nginx could not be installed."
    exit 1
fi

sed -i "s/IP_ADDRESS/${IP_ADDRESS}/g" ./reference/my_server;
if [[ $? -ne 0 ]]
then
    echo "IP_ADDRESS ${IP_ADDRESS} could not be added to my_server."
    exit 1
fi

sed -i "s/DOMAIN/${2}/g" ./reference/my_server;
if [[ $? -ne 0 ]]
then
    echo "DOMAIN ${DOMAIN} could not be added to my_server"
    exit 1
fi

sed -i "s/PORT/${3}/g" ./reference/my_server;
if [[ $? -ne 0 ]]
then
    echo "PORT ${PORT} could not be added to my_server"
    exit 1
fi

# Move to folder and create symlink...
sudo mv reference/my_server /etc/nginx/sites-available/my_server # Move new file into nginx's server directory...
cd /etc/nginx/sites-enabled
sudo ln -s ../sites-available/my_server

# Configure firewall
sudo ufw allow ssh

if [[ "${?}" -ne 0 ]]
then
    echo "Could not configure firewall. Current UFW status:"
    sudo ufw status
    exit 1
fi

sudo ufw allow "Nginx Full"

if [[ "${?}" -ne 0 ]]
then
    echo "Could not configure firewall. Current UFW status:"
    sudo ufw status
    exit 1
fi

sudo ufw enable # Turn on firewall...

# Remove old server block and symlink...
sudo rm /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
if [[ $? -ne 0 ]]
then
    echo "Could not remove old server bloc."
    exit 1
fi

# Test config...
sudo nginx -t 

if [[ $? -ne 0 ]]
then
    echo "Nginx was not properly configured."
    exit 1
fi

# Reload settings
sudo systemctl reload nginx

echo "Nginx successfully configured."
rm "${0}"
