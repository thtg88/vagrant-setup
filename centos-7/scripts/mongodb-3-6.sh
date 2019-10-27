#!/usr/bin/env bash

# Install and configure MongoDB

# Enable MongoDB.org repo
cat > /etc/yum.repos.d/mongodb-org.repo <<EOF
[mongodb-org-3.6]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/7Server/mongodb-org/3.6/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.6.asc
EOF

# Install MongoDB
yum install -y mongodb-org

# Configure number of processes for MongoDB
sed -i 's"^mongod soft nproc.*$"mongod soft nproc 32000"' /etc/security/limits.d/20-nproc.conf

# Enable and start MongoDB
mkdir -p /data/db
systemctl enable mongod
systemctl start mongod
