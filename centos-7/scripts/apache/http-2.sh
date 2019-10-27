#!/usr/bin/env bash

# Install and configure Apache (httpd)
# with HTTP/2 support (from CodeIT repo)

# Enable CodeIT repo
cd /etc/yum.repos.d && wget https://repo.codeit.guru/codeit.el`rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release)`.repo

# Install Apache
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

# Generate localhost certificates
openssl genrsa -out /etc/pki/tls/private/localhost.key 2048
openssl req -new -x509 -key /etc/pki/tls/private/localhost.key -out /etc/pki/tls/certs/localhost.crt -days 3650 -subj /CN=localhost

# Enable and start Apache
systemctl enable httpd.service
systemctl start httpd.service
