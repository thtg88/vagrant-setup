#!/usr/bin/env bash
# Update CentOS packages
yum update -y
# Install bind-utils, patch, vim, wget, and epel-release
# We install nodejs for Ruby to have a JS dev environment
yum install -y yum-utils bind-utils patch vim nano wget epel-release net-tools zip unzip git
# Install Apache (httpd), MariaDB, and its extensions from the local repo
yum install -y httpd httpd-devel epel-release mod_ssl nodejs
# Update CentOS packages
yum -y update
mkdir -p /var/www/certificates
mkdir -p /var/www/vhosts
# disable SELinux
sed -i 's"^SELINUX=.*$"SELINUX=disabled"' /etc/selinux/config
# set system timezone
timedatectl set-timezone Europe/London
# Set ServerName vagrant.localhost
sed -i 's"^#ServerName .*$"ServerName vagrant.localhost"' /etc/httpd/conf/httpd.conf
# configure Apache
mkdir /etc/httpd/sites-available
mkdir /etc/httpd/sites-enabled
# Configure Apache to run as the vagrant user
sed -i 's"^User .*$"User vagrant"' /etc/httpd/conf/httpd.conf
# Configure Apache to run as the vagrant group
sed -i 's"^Group .*$"Group vagrant"' /etc/httpd/conf/httpd.conf
echo >> /etc/httpd/conf/httpd.conf
echo Include /etc/httpd/sites-enabled/ >> /etc/httpd/conf/httpd.conf
# enable and start Apache services
systemctl enable httpd.service
systemctl start httpd.service
# Download RVM keys
gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
# Download RVM
curl -sSL https://get.rvm.io | bash -s stable
source /usr/local/rvm/scripts/rvm || source /etc/profile.d/rvm.sh
rvm use --default --install 2.6.3
gem install bundler
gem install rails
rvm cleanup all
# Change permissions to wrappers directory so "rails new app_name" works
chown -R vagrant /usr/local/rvm/gems/ruby-2.6.3/wrappers
# Make sure clock is updated (otherwise this causes an issue with Passenger)
yum install -y ntp
chkconfig ntpd on
ntpdate pool.ntp.org
service ntpd start
# Enable EPEL repo
yum-config-manager --enable epel
yum clean all && sudo yum update -y
# Install Phusion Passenger pre-requisites
yum install -y pygpgme curl
# Add Phusion Passenger repository
curl --fail -sSLo /etc/yum.repos.d/passenger.repo https://oss-binaries.phusionpassenger.com/yum/definitions/el-passenger.repo
# Install Passenger + Apache module
yum install -y mod_passenger || sudo yum-config-manager --enable cr && sudo yum install -y mod_passenger
yum install -y passenger-devel-6.0.2
systemctl restart httpd.service
# Configuring Passenger to point to RVM version of Ruby
sed -i 's"PassengerRuby .*$"PassengerRuby /usr/local/rvm/rubies/ruby-2.6.3/bin/ruby"' /etc/httpd/conf.d/passenger.conf
echo "<IfModule mod_passenger.c>
    PassengerAppEnv development
</IfModule>" >> /etc/httpd/conf.d/passenger.conf
