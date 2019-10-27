#!/usr/bin/env bash

# Base system configuration
# PLEASE NOTE: this script must be executed before any other

# Update CentOS packages
yum update -y

# Install useful packages
yum install -y bind-utils patch vim nano wget epel-release net-tools zip unzip git

# Disable SELinux
sed -i 's"^SELINUX=.*$"SELINUX=disabled"' /etc/selinux/config

# Set system timezone
timedatectl set-timezone Europe/London
