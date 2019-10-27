#!/usr/bin/env bash

# Install SQL Server
curl -o /etc/yum.repos.d/mssql-server.repo https://packages.microsoft.com/config/rhel/7/mssql-server-2017.repo
yum install -y mssql-server
