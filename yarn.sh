#!/bin/bash

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
