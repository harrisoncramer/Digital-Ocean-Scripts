#!/bin/bash

# Install Nginx server

echo "Installing Nginx..."

sudo apt update
sudo apt install nginx
sudo ufw allow 'Nginx HTTP'
sudo systemctl start nginx

if [[ $? -ne 0 ]]
then
    echo "Nginx could not be installed."
    exit 1
fi

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

sudo ufw enable 

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
