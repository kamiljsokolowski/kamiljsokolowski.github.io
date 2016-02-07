#!/usr/bin/env bash

OLDSTABLE='2.1.1'
STABLE='2.1.7'

sudo apt-get update && sudo apt-get install -y \
    nodejs \
    git

# setup Jekyll platform with rvm and bundler
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable
source /home/vagrant/.rvm/scripts/rvm

for INT in ${OLDSTABLE} ${STABLE}; do
    rvm install ${INT}
    rvm ${INT}@global do gem install bundler
done

# (old-stable)
rvm use ${OLDSTABLE}
rvm gemset create blog-oldstable
rvm use ${OLDSTABLE}@blog-oldstable --default
# need to co version repo tagged github-pages=43 and add dependencies to oldstable gemset
# ...

# (stable)
rvm --default use ${STABLE}
rvm gemset create blog-stable
rvm use ${STABLE}@blog-stable --default
cd /vagrant
if [ -f /vagrant/Gemfile.lock ]; then
    rm -f /vagrant/Gemfile.lock
fi
rvm @blog-stable do bundle install
cd

