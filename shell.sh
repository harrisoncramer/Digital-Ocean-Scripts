#!/bin/bash

# Set default shell to bash
chsh -s /bin/bash

# Install Neovim
sudo apt install neovim

# Configure Neovim to use .vimrc file
mkdir ~/.config/nvim
touch ~/.config/nvim/init.vim

# Let NVIM and VIM share configuration files
echo "set runtimepath^=~/.vim runtimepath+=~/.vim/after" >> ~/.vimrc
echo "let &packpath=&runtimepath" >> ~/.vimrc
source ~/.vimrc

# Install vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
