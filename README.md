These scripts set up an environment for a node server running on Ubuntu 18.04 on Digital Ocean. They should be run in order.

# setup.sh

Setup creates a user, provides the user with sudo privileges, and sets an automatic password.
Requires logging back out and in with the user to reconfigure the password.

# mongodb.sh

Installs version 4.2 of mongodb and runs as a service. You must subsequently configure the MongoDB server with user controlled access.

# Vim Plug
Installs vim-plug for managing plugins.


# services.sh 

This runs all of the installations necessary for a basic node.js app.
It installs Node.js, MongoDB, Yarn, PM2, and Git.

# nginx.sh

This installs and configures Nginx as a reverse proxy, sending HTTP traffic to port 3000.
The node application can then send and recieve information on that port.
