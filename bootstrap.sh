#!/usr/bin/env bash

sudo apt-get -y install ruby ruby-dev make nodejs git
sudo gem install jekyll --no-rdoc --no-ri

# dotfiles
mkdir .dotfiles
cd .dotfiles
git clone https://github.com/sokolowskik/dotfiles.git .
chmod +x bootstrap.sh
./bootstrap.sh
