#!/bin/bash

echo "Configuring Nginx..."

sudo apt-get update -qq
sudo apt-get install nginx --yes

sleep 15
sudo ufw allow 'Nginx HTTP'

if [[ $? -ne 0 ]]
then
    echo "Nginx could not be configured."
    exit 1
fi

# Remove old server block and symlink...
sudo rm /etc/nginx/sites-available/default
sudo rm /etc/nginx/sites-enabled/default

if [[ $? -ne 0 ]]
then
    echo "Could not remove old server bloc."
    exit 1
fi

sudo mv my_server /etc/nginx/sites-available/my_server # Move new file into nginx's server directory...

# Create symlink to enabled sites...
cd /etc/nginx/sites-enabled
sudo ln -s ../sites-available/my_server

# Test config...
sudo nginx -t 

if [[ $? -ne 0 ]]
then
    echo "Nginx was not properly configured."
    exit 1
fi

echo "Nginx successfully configured."
rm "${0}"

## 0b4c8e73+