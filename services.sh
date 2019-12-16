#!/usr/bin/env bash

# Packages
NODE="nodejs"
BUILD_ESSENTIAL="build-essential"
MONGO="mongodb-org"
GIT="git"
YARN="yarn"

# Prerequisites
GIT_INSTALLED=$(dpkg-query -W --showformat='${Status}\n' $GIT | grep "install ok installed")
echo "Checking for $GIT: $GIT_INSTALLED"
if [ "" == "$GIT_INSTALLED" ]; then
 apt-get update -qq
 apt-get install -y $GIT -qq
fi

if [[ ${?} -ne 0 ]]
then
  echo "Could not install GIT."
  exit 1
fi


# MongoDB https://docs.mongodb.com/manual/tutorial/install-mongodb-on-ubuntu/
MONGO_INSTALLED=$(dpkg-query -W --showformat='${Status}\n' $MONGO | grep "install ok installed")
echo "Checking for $MONGO: $MONGO_INSTALLED"
if [ "" == "$MONGO_INSTALLED" ]; then
 wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
 echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
 sudo apt-get update -qq
 sudo apt-get install -y mongodb-org -qq
    ## sudo chmod +w /etc/mongod.conf
    ## sudo sed -i 's/\ \ bindIp:\ 127.0.0.1/  bindIp: 0.0.0.0/g' /etc/mongod.conf # Unclear on the binding situation in digital ocean...
 sudo service mongod start
fi

if [[ ${?} -ne 0 ]]
then
  echo "Could not install and startup MongoDB."
  exit 1
fi

# Node.js
NODE_INSTALLED=$(dpkg-query -W --showformat='${Status}\n' $NODE | grep "install ok installed")
echo "Checking for $NODE: $NODE_INSTALLED"
if [ "" == "$NODE_INSTALLED" ]; then
 curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
 apt-get install -y build-essential nodejs -qq
fi

if [[ ${?} -ne 0 ]]
then
  echo "Could not install NodeJS."
  exit 1
fi

# Yarn
YARN_INSTALLED=$(dpkg-query -W --showformat='${Status}\n' $YARN | grep "install ok installed")
echo "Checking for Yarn: ${YARN_INSTALLED}"
if [ "" == "$YARN_INSTALLED" ]; then
  curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt-get update -qq
  sudo apt-get install -y yarn -qq
fi

if [[ ${?} -ne 0 ]]
then
  echo "Could not install Yarn."
  exit 1
fi

# Pm2
# No harm in repeat installation...
yarn global add pm2

if [[ ${?} -ne 0 ]]
then
  echo "Could not install Yarn."
  exit 1
fi

echo "Provisioning complete."
rm "${0}"