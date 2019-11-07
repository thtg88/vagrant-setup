#!/usr/bin/env bash

# Install and Configure PHP 5.4

# Install PHP 5.4 (default CentOS PHP version) and its extensions
yum -y install php php-bcmath php-xml php-mcrypt php-gd php-devel php-mysql php-intl php-mbstring php-soap php-pgsql

# Create PHP Session folder and enable writing access
mkdir -p /var/lib/php/session
chmod -R 777 /var/lib/php/session

# Set short_open_tag = On
sed -i 's"^short_open_tag =.*$"short_open_tag = On"' /etc/php.ini

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
