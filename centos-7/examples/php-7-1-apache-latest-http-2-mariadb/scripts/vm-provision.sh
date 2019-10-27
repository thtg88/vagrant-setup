# Update CentOS packages
yum update -y
# Install bind-utils, patch, nano, vim, wget, and epel-release
yum install -y bind-utils patch nano vim wget epel-release zip unzip
# libpng-devel
# Fetch the remi repo
wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
# Update repo packages
yum --enablerepo=remi,remi-php72 update
# Install Apache (httpd), MariaDB, Git, and its extensions from the local repo
yum --enablerepo=remi,remi-php72 install -y mariadb-server git
# Fetch the CentOS 7 additional rpms
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
wget https://centos7.iuscommunity.org/ius-release.rpm
# Install and upgrade the rpms just downloaded
rpm -Uvh ius-release*.rpm
# Update CentOS packages
yum -y update
# Enable CodeIT repo
cd /etc/yum.repos.d && wget https://repo.codeit.guru/codeit.el`rpm -q --qf "%{VERSION}" $(rpm -q --whatprovides redhat-release)`.repo
# Install Apache
yum install -y httpd
# Now that we have the official CentOS repo, install PHP 7.1 and its extensions
yum install -y centos-release-scl yum-utils mod_ssl
yum-config-manager --enable rhel-server-rhscl-7-rpms
yum -y install rh-php71 rh-php71-php-fpm rh-php71-php-opcache rh-php71-php-bcmath rh-php71-php-xml rh-php71-php-mcrypt rh-php71-php-gd rh-php71-php-devel rh-php71-php-mysql rh-php71-php-intl rh-php71-php-mbstring rh-php71-php-json rh-php71-php-soap rh-php71-php-pdo rh-php71-php-pdo_mysql rh-php71-php-mbstring
# Install SQL Server
curl -o /etc/yum.repos.d/mssql-server.repo https://packages.microsoft.com/config/rhel/7/mssql-server-2017.repo
yum install -y mssql-server
# Install MongoDB
cat > /etc/yum.repos.d/mongodb-org.repo <<EOF
[mongodb-org-3.6]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/7Server/mongodb-org/3.6/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.6.asc
EOF
yum install -y mongodb-org
# configure PHP
systemctl enable rh-php71-php-fpm
systemctl daemon-reload
systemctl start rh-php71-php-fpm
# Enable writing of PHP Session folder
mkdir /var/lib/php
mkdir /var/lib/php/session
chmod -R 777 /var/lib/php/session
# Set short_open_tag = On
sed -i 's"^short_open_tag =.*$"short_open_tag = On"' /etc/opt/rh/rh-php71/php.ini
# Set display_errors = On
sed -i 's"^display_errors =.*$"display_errors = On"' /etc/opt/rh/rh-php71/php.ini
# Set upload_max_filesize = 256M
sed -i 's"^upload_max_filesize =.*$"upload_max_filesize = 256M"' /etc/opt/rh/rh-php71/php.ini
sed -i 's"^post_max_size =.*$"post_max_size = 100M"' /etc/opt/rh/rh-php71/php.ini
# Set date.timezone = Europe/London
sed -i 's"^;date\.timezone =.*$"date.timezone = Europe/London"' /etc/opt/rh/rh-php71/php.ini
# Set sendmail_path = /usr/sbin/ssmtp -t
sed -i 's"^sendmail_path =.*$"sendmail_path = /usr/sbin/ssmtp -t"' /etc/opt/rh/rh-php71/php.ini
sed -i 's"^user =.*$"user = vagrant"' /etc/opt/rh/rh-php71/php-fpm.d/www.conf
sed -i 's"^group =.*$"group = vagrant"' /etc/opt/rh/rh-php71/php-fpm.d/www.conf
# make php available from CLI at every boot
source scl_source enable rh-php71
cat > /etc/profile.d/enablephpcli.sh <<EOF
#!/bin/bash
source scl_source enable rh-php71
EOF
# disable SELinux
sed -i 's"^SELINUX=.*$"SELINUX=disabled"' /etc/selinux/config
# set system timezone
timedatectl set-timezone Europe/London
# Set MySQL's auto_increment_increment and auto_increment_offset to 2
# to emulate the live server's behaviour
sed -i 's"^\[mysqld\].*$"\[mysqld\]\nauto_increment_increment=2\nauto_increment_offset=2"' /etc/my.cnf
# enable and start MariaDB service
systemctl enable mariadb.service
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
# Configure number of processes for MongoDB
sed -i 's"^mongod soft nproc.*$"mongod soft nproc 32000"' /etc/security/limits.d/20-nproc.conf
# Enable & Start MongoDB
mkdir /data
mkdir /data/db
systemctl enable mongod
systemctl start mongod
# configure Apache
# Set ServerName vagrant.localhost
sed -i 's"^#ServerName .*$"ServerName vagrant.localhost"' /etc/httpd/conf/httpd.conf
# configure Apache
mkdir /etc/httpd/sites-available
mkdir /etc/httpd/sites-enabled
mkdir /var/www/certificates
# Configure Apache to run as the vagrant user
sed -i 's"^User .*$"User vagrant"' /etc/httpd/conf/httpd.conf
# Configure Apache to run as the vagrant group
sed -i 's"^Group .*$"Group vagrant"' /etc/httpd/conf/httpd.conf
echo >> /etc/httpd/conf/httpd.conf
echo Include /etc/httpd/sites-enabled/ >> /etc/httpd/conf/httpd.conf
# Load correct PHP mpm module
sed -i 's"^LoadModule mpm_worker_module.*$"#LoadModule mpm_worker_module modules/mod_mpm_worker.so"' /etc/httpd/conf.modules.d/00-mpm.conf
sed -i 's"^#LoadModule mpm_event_module.*$"LoadModule mpm_event_module modules/mod_mpm_event.so"' /etc/httpd/conf.modules.d/00-mpm.conf
# Generate localhost certificates
openssl genrsa -out /etc/pki/tls/private/localhost.key 2048
openssl req -new -x509 -key /etc/pki/tls/private/localhost.key -out /etc/pki/tls/certs/localhost.crt -days 3650 -subj /CN=localhost
# Enable and start Apache
systemctl enable httpd.service
# Install Composer
EXPECTED_SIGNATURE=$(wget https://composer.github.io/installer.sig -O - -q)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")
if [ "$EXPECTED_SIGNATURE" = "$ACTUAL_SIGNATURE" ]
then
    php composer-setup.php --quiet
    mv composer.phar /usr/local/bin/composer
    cat > /etc/profile.d/addcomposertopath.sh <<EOF
#!/bin/bash
PATH=\$PATH:/root/.config/composer/vendor/bin:/home/vagrant/.config/composer/vendor/bin
EOF
else
    >&2 echo 'ERROR: Invalid installer signature'
fi
rm composer-setup.php
# TODO
#/opt/mssql/bin/mssql-conf setup
#composer global require "banago/phploy"
#composer global require "laravel/installer"