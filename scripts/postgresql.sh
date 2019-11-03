#!/usr/bin/env bash

# Install and configure PostgreSQL

# As of this writing, the CentOS 7 repositories ship
# with PostgreSQL version 9.2.15
yum install -y postgresql-server postgresql-contrib

# Initialize your Postgres database and start PostgreSQL
postgresql-setup initdb
systemctl start postgresql

# Configure PostgreSQL to start on boot
systemctl enable postgresql
