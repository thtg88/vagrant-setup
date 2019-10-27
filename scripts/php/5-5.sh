#!/usr/bin/env bash

# Install and Configure PHP 5.5

# Download and unpack Webtatic repo
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

# Install PHP 5.5 (from webtatic repo) and its extensions
yum -y install php55w php55w-opcache php55w-bcmath php55w-xml php55w-mcrypt php55w-gd php55w-devel php55w-mysql php55w-intl php55w-mbstring php55w-soap

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
