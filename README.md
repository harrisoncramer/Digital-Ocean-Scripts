Utility scripts for configuring an EC2 instance (Ubuntu)

# setup.sh

Setup creates a user, provides the user with sudo privileges, and sets an automatic password.

# shell.sh

Configures ZSH as user's shell w/ oh-my-zsh installed.

# docker.sh

Installs Docker and docker-compose.

# node.sh

Installs nvm and node.js version 13.7.0 and sets up user to automatically use those versions. You must log out and login to reload the installation.

# ssh.sh

Creates a new SSH key and adds it to the ssh-agent. You must manually then <a href="https://help.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account">add the keys</a> to your Github account.

# nginx

Starts an Nginx server, starts the firewall, and allows HTTP/HTTPS traffic into the server. Turn <a href="https://docs.mongodb.com/manual/tutorial/enable-authentication/">on authorization</a> for the server.

# packages.sh

This is a collection of useful applications for development on the Ubuntu server. It includes:

1. Yarn
2. PM2
3. Artillery
4. GoAccess
