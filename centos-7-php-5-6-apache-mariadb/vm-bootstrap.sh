# Update CentOS packages
yum update -y
# Install bind-utils, patch, vim, wget, and epel-release
yum install -y bind-utils patch vim nano wget epel-release net-tools unzip zip git
# Fetch the remi repo
wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
# Update repo packages
yum --enablerepo=remi,remi-php56 update
# Install Apache (httpd), MariaDB, NodeJS, and its extensions from the local repo
yum --enablerepo=remi,remi-php56 install -y httpd mariadb-server nodejs
# php-bcmath
# Fetch the CentOS 7 official rpms
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
wget https://centos7.iuscommunity.org/ius-release.rpm
# Install and upgrade the rpms just downloaded
rpm -Uvh ius-release*.rpm
# Update CentOS packages
yum -y update
# Now that we have the official CentOS repo, install PHP 5.6 and its extensions
yum -y install php56u php56u-opcache php56u-bcmath php56u-xml php56u-mcrypt php56u-gd php56u-devel php56u-mysql php56u-intl php56u-mbstring php56u-soap mod_ssl
# Enable writing of PHP Session folder
chmod -R 777 /var/lib/php/session
# disable SELinux
sed -i 's"^SELINUX=.*$"SELINUX=disabled"' /etc/selinux/config
# set system timezone
timedatectl set-timezone Europe/London
# configure PHP
# Set short_open_tag = On
sed -i 's"^short_open_tag =.*$"short_open_tag = On"' /etc/php.ini
# Set display_errors = On
sed -i 's"^display_errors =.*$"display_errors = On"' /etc/php.ini
# Set upload_max_filesize = 256M
sed -i 's"^upload_max_filesize =.*$"upload_max_filesize = 256M"' /etc/php.ini
# Set date.timezone = Europe/London
sed -i 's"^;date\.timezone =.*$"date.timezone = Europe/London"' /etc/php.ini
# Set sendmail_path = /usr/sbin/ssmtp -t
sed -i 's"^sendmail_path =.*$"sendmail_path = /usr/sbin/ssmtp -t"' /etc/php.ini
# Set ServerName vagrant.localhost
sed -i 's"^#ServerName .*$"ServerName vagrant.localhost"' /etc/httpd/conf/httpd.conf
# configure Apache
mkdir /etc/httpd/sites-available
mkdir /etc/httpd/sites-enabled
# Configure Apache to run as the vagrant user
sed -i 's"^User .*$"User vagrant"' /etc/httpd/conf/httpd.conf
# Configure Apache to run as the vagrant group
sed -i 's"^Group .*$"Group vagrant"' /etc/httpd/conf/httpd.conf
echo >> /etc/httpd/conf/httpd.conf
echo Include /etc/httpd/sites-enabled/ >> /etc/httpd/conf/httpd.conf
# enable and start Apache and MariaDB services
systemctl enable httpd.service
systemctl enable mariadb.service
systemctl start httpd.service
systemctl start mariadb.service
# Install Composer
EXPECTED_SIGNATURE=$(wget https://composer.github.io/installer.sig -O - -q)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")
if [ "$EXPECTED_SIGNATURE" = "$ACTUAL_SIGNATURE" ]
then
	php composer-setup.php --quiet
	mv composer.phar /usr/local/bin/composer
else
	>&2 echo 'ERROR: Invalid installer signature'
fi
rm composer-setup.php
