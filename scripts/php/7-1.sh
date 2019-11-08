#!/usr/bin/env bash

# Install and Configure PHP 7.1

# Download and unpack Webtatic repo
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

# Install PHP 7.1 (from webtatic repo) and its extensions
yum -y install php71w php71w-opcache php71w-bcmath php71w-xml php71w-mcrypt php71w-gd php71w-devel php71w-mysql php71w-intl php71w-mbstring php71w-soap php71w-pgsql

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
