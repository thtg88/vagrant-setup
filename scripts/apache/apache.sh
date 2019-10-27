#!/usr/bin/env bash

# Install and configure Apache (httpd)

# Install Apache (httpd)
yum install -y httpd mod_ssl

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
