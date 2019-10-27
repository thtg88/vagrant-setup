#!/usr/bin/env bash

# Install and Configure PHP-FPM 7.1

# Install Configs and basic docs for Software Collections as delivered via the CentOS SCLo SIG only
yum install -y centos-release-scl yum-utils

# Enable RHEL7 RPMs
yum-config-manager --enable rhel-server-rhscl-7-rpms

# Install RHEL PHP-FPM 7.1 and its extension
yum -y install rh-php71 rh-php71-php-fpm rh-php71-php-opcache rh-php71-php-bcmath rh-php71-php-xml rh-php71-php-mcrypt rh-php71-php-gd rh-php71-php-devel rh-php71-php-mysql rh-php71-php-intl rh-php71-php-mbstring rh-php71-php-json rh-php71-php-soap rh-php71-php-pdo rh-php71-php-pdo_mysql rh-php71-php-mbstring

# Enable and start RHEL PHP-FPM service
systemctl enable rh-php71-php-fpm
systemctl daemon-reload
systemctl start rh-php71-php-fpm

# Enable writing of PHP Session folder
mkdir -p /var/lib/php/session
chmod -R 777 /var/lib/php/session

# Set short_open_tag = On
sed -i 's"^short_open_tag =.*$"short_open_tag = On"' /etc/opt/rh/rh-php71/php.ini

# Set display_errors = On
sed -i 's"^display_errors =.*$"display_errors = On"' /etc/opt/rh/rh-php71/php.ini

# Set upload_max_filesize = 256M
sed -i 's"^upload_max_filesize =.*$"upload_max_filesize = 256M"' /etc/opt/rh/rh-php71/php.ini

# Set post_max_size = 100M
sed -i 's"^post_max_size =.*$"post_max_size = 100M"' /etc/opt/rh/rh-php71/php.ini

# Set date.timezone = Europe/London
sed -i 's"^;date\.timezone =.*$"date.timezone = Europe/London"' /etc/opt/rh/rh-php71/php.ini

# Set sendmail_path = /usr/sbin/ssmtp -t
sed -i 's"^sendmail_path =.*$"sendmail_path = /usr/sbin/ssmtp -t"' /etc/opt/rh/rh-php71/php.ini

# Set user and group for PHP-FPM as "vagrant"
sed -i 's"^user =.*$"user = vagrant"' /etc/opt/rh/rh-php71/php-fpm.d/www.conf
sed -i 's"^group =.*$"group = vagrant"' /etc/opt/rh/rh-php71/php-fpm.d/www.conf

# Make php available from CLI at every boot
source scl_source enable rh-php71
cat > /etc/profile.d/enablephpcli.sh <<EOF
#!/bin/bash
source scl_source enable rh-php71
EOF

# Unload Apache PHP mpm worker module
sed -i 's"^LoadModule mpm_worker_module.*$"#LoadModule mpm_worker_module modules/mod_mpm_worker.so"' /etc/httpd/conf.modules.d/00-mpm.conf

# Load Apache PHP mpm event module
sed -i 's"^#LoadModule mpm_event_module.*$"LoadModule mpm_event_module modules/mod_mpm_event.so"' /etc/httpd/conf.modules.d/00-mpm.conf
