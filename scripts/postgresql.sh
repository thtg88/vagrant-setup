#!/usr/bin/env bash

# Install and configure PostgreSQL

# As of this writing, the CentOS 7 repositories ship
# with PostgreSQL version 9.2.15
yum install -y postgresql-server postgresql-contrib postgresql-devel

# Initialize your Postgres database and start PostgreSQL
sudo -u postgres postgresql-setup initdb

chown postgres:postgres -R /var/lib/pgsql

systemctl start postgresql

# Configure PostgreSQL to start on boot
systemctl enable postgresql

# Create vagrant postgres superuser
sudo -u postgres createuser -s vagrant

# Add host machine IP address to white-list
sudo sed -i "s/^host    all             all             127\.0\.0\.1\/32.*$/#host all all 127\.0\.0\.1\/32 ident/" /var/lib/pgsql/data/pg_hba.conf
sudo cat >> /var/lib/pgsql/data/pg_hba.conf <<EOF
host all all 10.0.2.2/24 trust
host all all 127.0.0.1/32 trust
EOF

# Listen connections from all addresses
sudo sed -i "s/^#listen_addresses =.*$/listen_addresses = '*'/" /var/lib/pgsql/data/postgresql.conf

# Restart
systemctl restart postgresql
