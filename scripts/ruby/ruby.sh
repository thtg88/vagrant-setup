#!/usr/bin/env bash

# Install and configure Ruby (via RVM)

# Download RVM keys
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB

# Download RVM
curl -sSL https://get.rvm.io | bash -s stable
source /usr/local/rvm/scripts/rvm || source /etc/profile.d/rvm.sh

# Make RVM available in shell
source /home/vagrant/.rvm/scripts/rvm

# Install Ruby 2.6.3 and set as default version
rvm use --default --install 2.6.3

# Install bundler and rails
gem install bundler
gem install rails
rvm cleanup all
