# Vagrant Setup
This collection of Vagrant configurations aims at gathering common development environments.

## Table of Contents

* [Contained in this repository](#contained-in-this-repository)
* [Requirements](#requirements)

## Contained in this repository
- CentOS 7
    - PHP 5.6 with stock Apache and MariaDB
        - Basic HTTP configuration
        - Dynamic HTTPS self-signed certificate configuration
    - PHP 7.1 with latest Apache from CodeIT repo and MariaDB, together with HTTPS and HTTP/2 configuration out of the box

## Requirements
- Basic understanding of virtualization, networking, and VMs
- [VirtualBox](https://www.virtualbox.org/) 5.2.x. While this setup may work with other hypervisors, it has not been tested against them and support is not provided for them
- Vagrant 2.2.0 or higher
