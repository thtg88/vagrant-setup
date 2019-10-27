# Update CentOS packages
yum update -y
# Install bind-utils, patch, vim, wget, and epel-release
yum install -y bind-utils patch vim nano wget epel-release net-tools zip unzip git
# Fetch the remi repo
wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
# Update repo packages
yum --enablerepo=remi,remi-php56 update
# Install Apache (httpd), MariaDB, and its extensions from the local repo
yum --enablerepo=remi,remi-php56 install -y httpd mariadb-server
# Fetch the CentOS 7 official rpms
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
wget https://centos7.iuscommunity.org/ius-release.rpm
# Install and upgrade the rpms just downloaded
rpm -Uvh ius-release*.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
# Update CentOS packages
yum -y update
# Now that we have the official CentOS repo, install PHP 5.6 and its extensions
yum -y install php56w php56w-opcache php56w-bcmath php56w-xml php56w-mcrypt php56w-gd php56w-devel php56w-mysql php56w-intl php56w-mbstring php56w-soap mod_ssl
mkdir /var/www/certificates
mkdir -p /var/lib/php/session
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
sed -i 's"^post_max_size =.*$"post_max_size = 100M"' /etc/php.ini
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
# Set MySQL's auto_increment_increment and auto_increment_offset to 2
# to emulate the live server's behaviour
sed -i 's"^\[mysqld\].*$"\[mysqld\]\nauto_increment_increment=2\nauto_increment_offset=2"' /etc/my.cnf
# enable and start Apache and MariaDB services
systemctl enable httpd.service
systemctl enable mariadb.service
systemctl start httpd.service
systemctl start mariadb.service
# set MySQL root password
sudo /usr/bin/mysqladmin -u root password 'root'
# allow MySQL remote access (required to access from our private network host. Note that this is completely insecure if used in any other way)
mysql -u root -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION; FLUSH PRIVILEGES;"
# allow MySQL remote access to somdes (required to access from our private network host. Note that this is completely insecure if used in any other way)
mysql -u root -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'user'@'%' IDENTIFIED BY 'usersecret' WITH GRANT OPTION;"
# drop the MySQL anonymous users
mysql -u root -proot -e "DROP USER ''@'localhost';"
mysql -u root -proot -e "DROP USER ''@'$(hostname)';"
# drop the MySQL demo database
mysql -u root -proot -e "DROP DATABASE test;"
# reload MySQL privileges table
mysql -u root -proot -e "FLUSH PRIVILEGES;"
# enable and start MariaDB service
systemctl restart mariadb.service
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
