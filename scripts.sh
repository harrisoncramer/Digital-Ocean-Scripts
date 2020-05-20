#!/bin/bash

echo "Adding scripts and sourcing filepath in PATH for user";

mkdir ~/Scripts
mv ./reference/scripts/* ~/Scripts

echo 'export PATH="$HOME/Scripts:$PATH"' >> ~/.zshrc

echo "Re-source your ~/.zshrc file"

