#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script must be be run as root." 
   exit 1
fi


# Install pip + dependencies
sudo apt install libpq-dev
sudo apt-get install python3-pip

pip3 install pgcli
