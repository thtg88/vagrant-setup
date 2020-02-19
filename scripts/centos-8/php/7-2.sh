#!/usr/bin/env bash

# Install and Configure PHP 7.2

# Install PHP and its extensions
yum -y install php php-opcache php-bcmath php-xml php-gd php-devel php-mysqlnd php-intl php-mbstring php-soap php-pgsql

# Start the FPM service and enable it to automatically start on boot
systemctl enable --now php-fpm

# Restart Apache
systemctl restart httpd

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
