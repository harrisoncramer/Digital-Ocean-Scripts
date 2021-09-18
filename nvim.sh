#!/bin/bash

if [[ $EUID -eq 0 ]]; then
   echo "This script should not run as root" 
   exit 1
fi

# Set default shell to bash
sudo chsh -s /bin/bash

# Install Neovim
sudo apt update
sudo apt install neovim -y

# Configure Neovim to use .vimrc file
mkdir -p ~/.config/nvim
touch ~/.config/nvim/init.vim
