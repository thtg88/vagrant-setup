#!/usr/bin/env bash

# Install and configure SQL Server
curl -o /etc/yum.repos.d/mssql-server.repo https://packages.microsoft.com/config/rhel/7/mssql-server-2017.repo
yum install -y mssql-server

# Remember to run the following:
# sudo /opt/mssql/bin/mssql-conf setup
# Password1234
