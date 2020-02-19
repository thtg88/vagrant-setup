#!/usr/bin/env bash

# Install and Configure PHP 7.4

# Enable the Remi repository
dnf install -y dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm

# Enable PHP 7.4 for install
dnf module reset php
dnf module enable -y php:remi-7.4

# Install PHP and its extensions
dnf install -y php php-opcache php-bcmath php-xml php-gd php-mysqlnd php-intl php-mbstring php-soap php-pgsql php-zip

# Start the FPM service and enable it to automatically start on boot
systemctl enable --now php-fpm

# Set display_errors = On
sed -i 's"^display_errors =.*$"display_errors = On"' /etc/php.ini

# Set upload_max_filesize = 256M
sed -i 's"^upload_max_filesize =.*$"upload_max_filesize = 256M"' /etc/php.ini

# Set post_max_size = 100M
sed -i 's"^post_max_size =.*$"post_max_size = 100M"' /etc/php.ini

# Set date.timezone = Europe/London
sed -i 's"^;date\.timezone =.*$"date.timezone = Europe/London"' /etc/php.ini

# Set sendmail_path = /usr/sbin/ssmtp -t
sed -i 's"^sendmail_path =.*$"sendmail_path = /usr/sbin/ssmtp -t"' /etc/php.ini

# Restart Apache
systemctl restart httpd
