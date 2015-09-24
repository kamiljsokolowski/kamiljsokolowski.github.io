#!/usr/bin/env bash

sudo apt-get -y install nodejs git

# rvm
curl -sSL https://get.rvm.io | bash -s stable --ruby
source /home/vagrant/.rvm/scripts/rvm

# dotfiles
mkdir .dotfiles
cd .dotfiles
git clone https://github.com/sokolowskik/dotfiles.git .
chmod +x bootstrap.sh
./bootstrap.sh
