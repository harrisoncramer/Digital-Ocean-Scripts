#!/bin/bash

# Generate a new ssh key (https://help.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
ssh-keygen -t rsa -b 4096 -C "harrisoncramer@gmail.com"

# Start ssh-agent
eval "$(ssh-agent -s)"

# Add the key to the SSH-agent
ssh-add ~/.ssh/id_rsa

# Add this key to your Github Account.
echo 'https://help.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account'
