#!/usr/bin/env bash

sudo apt-get update && sudo apt-get install -y \
    nodejs \
    git \
    subversion

# RVM
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable
source /home/vagrant/.rvm/scripts/rvm
rvm install 2.1.1

# Bundler
rvm @global do gem install bundler

# Jekyll
rvm gemset create blog-stable
rvm gemset use  blog-stable
cd /vagrant
bundle install
cd

