#!/bin/bash

if [[ $EUID -eq 0 ]]; then
   echo "This script must not be run as root" 
   exit 1
fi

# Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update
sudo apt install -y yarn

if [[ ${?} -ne 0 ]]
then
  echo "Could not install Yarn."
fi

# Pm2
npm add pm2 -g

# goaccess
sudo apt install goaccess
