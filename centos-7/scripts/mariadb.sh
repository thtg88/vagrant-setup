#!/usr/bin/env bash

# Install and configure MariaDB

# Install MariaDB
yum install -y mariadb-server

# Set MySQL's auto_increment_increment and auto_increment_offset to 2
sed -i 's"^\[mysqld\].*$"\[mysqld\]\nauto_increment_increment=2\nauto_increment_offset=2"' /etc/my.cnf

# Enable and start MariaDB service
systemctl enable mariadb.service
systemctl start mariadb.service

# Set MySQL root password
sudo /usr/bin/mysqladmin -u root password 'root'

# Allow MySQL remote access (note that this is completely insecure if used in any other way)
mysql -u root -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'root' WITH GRANT OPTION; FLUSH PRIVILEGES;"

# Allow MySQL remote access to user (note that this is completely insecure if used in any other way)
mysql -u root -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'user'@'%' IDENTIFIED BY 'usersecret' WITH GRANT OPTION;"

# Drop the MySQL anonymous users
mysql -u root -proot -e "DROP USER ''@'localhost';"
mysql -u root -proot -e "DROP USER ''@'$(hostname)';"

# Drop the MySQL demo database
mysql -u root -proot -e "DROP DATABASE test;"

# Reload MySQL privileges table
mysql -u root -proot -e "FLUSH PRIVILEGES;"

# Restart MariaDB service
systemctl restart mariadb.service
