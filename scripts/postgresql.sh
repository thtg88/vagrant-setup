#!/usr/bin/env bash

# Install and configure PostgreSQL

# As of this writing, the CentOS 7 repositories ship
# with PostgreSQL version 9.2.15
yum install -y postgresql-server postgresql-contrib postgresql-devel

# Initialize your Postgres database and start PostgreSQL
postgresql-setup initdb
systemctl start postgresql

# Configure PostgreSQL to start on boot
systemctl enable postgresql

# Create vagrant postgres superuser
sudo -u postgres createuser -s vagrant

# Add host machine IP address to white-list
cat >> /var/lib/pgsql/data/pg_hba.conf <<EOF
host all all 10.0.2.2/24 trust
EOF

# Listen connections from all addresses
sed -i 's"^#listen_addresses = ''localhost''.*$"listen_addresses = ''*''"' /var/lib/pgsql/data/postgresql.conf

# Restart
systemctl restart postgresql
