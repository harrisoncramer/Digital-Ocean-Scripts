#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Digital Ocean comes pre-installed with MongoDB 3.6 We must uninstall that prior to our installation (see: https://docs.mongodb.com/manual/reference/installation-ubuntu-community-troubleshooting/#errors-when-running-sudo-apt-install-y-mongodb-org)
# "Unable to install package due to dpkg-deb: error"
# To see installed MONGODB packages, run: sudo apt list --installed | grep mongo
sudo apt remove mongodb -y
sudo apt purge mongodb -y
sudo apt autoremove -y

# Install MongoDB Community Edition 
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
sudo apt-get update -y
sudo apt-get install -y mongodb-org
sudo systemctl start mongod

# Run MongoDB as a service
sudo systemctl start mongod

echo "MongoDb Installed. Must configure a user admin and then enable access control in /etc/mongod.conf"
echo "Format (w/in admin db): db.createUser({ user: 'admin', pwd: 'password', roles: [{ role 'userAdminAnyDatabase', db: 'admin' }] })"
echo "Then in the /etc/mongod.conf file, uncomment #security, and below it, add the following ––> authorization: enabled"
echo "Restart Mongodb with sudo systemctl restart mongod"
