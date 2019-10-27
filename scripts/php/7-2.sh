#!/usr/bin/env bash

# Install and Configure PHP 7.2

# Download and unpack Webtatic repo
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

# Install PHP 7.2 (from webtatic repo) and its extensions
yum -y install php72w php72w-opcache php72w-bcmath php72w-xml php72w-mcrypt php72w-gd php72w-devel php72w-mysql php72w-intl php72w-mbstring php72w-soap

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
