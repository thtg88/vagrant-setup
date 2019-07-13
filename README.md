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
    - PHP 7.1 with latest Apache from [CodeIT](https://repo.codeit.guru/packages/centos/7/x86_64/) repo and MariaDB, together with HTTPS and HTTP/2 configuration out of the box
    - PHP 7.2 with MariaDB, and HTTPS configuration
        - Latest Apache from [CodeIT](https://repo.codeit.guru/packages/centos/7/x86_64/) repository, PHP-FPM, and together with HTTP/2 configuration out of the box
        - Stock Apache, and PHP from [Webtatic](https://webtatic.com/packages/php72/) repository
    - Ruby: Ruby 2.6.3 with RVM latest stable, together with Rails, Apache and MariaDB. The Passenger Apache module is used to serve Ruby apps.

## Requirements
- Basic understanding of virtualization, networking, and VMs
- [VirtualBox](https://www.virtualbox.org/) 5.2.x. While this setup may work with other hypervisors, it has not been tested against them and support is not provided for them
- Vagrant 2.2.0 or higher
