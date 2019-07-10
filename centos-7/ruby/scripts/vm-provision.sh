#!/usr/bin/env bash
# Update CentOS packages
yum update -y
# Install bind-utils, patch, vim, wget, and epel-release
yum install -y yum-utils bind-utils patch vim nano wget epel-release net-tools zip unzip git
# Install Apache (httpd), MariaDB, and its extensions from the local repo
yum install -y httpd httpd-devel mariadb-server epel-release
# Update CentOS packages
yum -y update
mkdir -p /var/www/certificates
mkdir -p /var/www/vhosts
# disable SELinux
sed -i 's"^SELINUX=.*$"SELINUX=disabled"' /etc/selinux/config
# set system timezone
timedatectl set-timezone Europe/London
# Set MySQL's auto_increment_increment and auto_increment_offset to 2
# to emulate the live server's behaviour
sed -i 's"^\[mysqld\].*$"\[mysqld\]\nauto_increment_increment=2\nauto_increment_offset=2"' /etc/my.cnf
# enable and start Apache and MariaDB services
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
# Enable EPEL repo
yum-config-manager --enable epel
yum clean all && sudo yum update -y
# Install Phusion Passenger pre-requisites
yum install -y pygpgme curl
# Add Phusion Passenger repository
curl --fail -sSLo /etc/yum.repos.d/passenger.repo https://oss-binaries.phusionpassenger.com/yum/definitions/el-passenger.repo
# Install Passenger + Apache module
yum install -y mod_passenger || sudo yum-config-manager --enable cr && sudo yum install -y mod_passenger
systemctl restart httpd
