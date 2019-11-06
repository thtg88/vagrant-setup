#!/usr/bin/env bash

# Install and configure Apache (httpd)
# with Phusion Passenger (for use with Ruby)

# Install Apache (httpd)
yum install -y httpd httpd-devel mod_ssl

# Create necessary folders
mkdir -p /var/www/certificates
mkdir -p /var/www/vhosts
mkdir -p /etc/httpd/sites-available
mkdir -p /etc/httpd/sites-enabled

# Set ServerName vagrant.localhost
sed -i 's"^#ServerName .*$"ServerName vagrant.localhost"' /etc/httpd/conf/httpd.conf

# Configure Apache to run as the vagrant user
sed -i 's"^User .*$"User vagrant"' /etc/httpd/conf/httpd.conf

# Configure Apache to run as the vagrant group
sed -i 's"^Group .*$"Group vagrant"' /etc/httpd/conf/httpd.conf

# Add sites-enabled conf files to Apache conf
echo >> /etc/httpd/conf/httpd.conf
echo Include /etc/httpd/sites-enabled/ >> /etc/httpd/conf/httpd.conf

# Enable and start Apache service
systemctl enable httpd.service
systemctl start httpd.service

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
sed -i 's"PassengerRuby .*$"PassengerRuby /home/vagrant/.rvm/rubies/ruby-2.6.3/bin/ruby"' /etc/httpd/conf.d/passenger.conf
echo "<IfModule mod_passenger.c>
    PassengerAppEnv development
</IfModule>" >> /etc/httpd/conf.d/passenger.conf
