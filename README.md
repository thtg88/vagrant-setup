# Vagrant Setup
This repository provides a set of scripts to construct a local Vagrant development VM.

## Table of Contents

- [Requirements](#requirements)
- [Technologies Provided](#technologies-provided)
- [Examples](#examples)
- [Installation](#installation)
- [Usage](#usage)
- [Configuration](#configuration)
    - [`forwarded_ports`](#forwarded_ports)
        - [`database` Backup Configuration](#database-backup-configuration)
        - [`synced_folder` Configuration](#synced_folder-configuration)
        - Example
    - [`projects`](#projects)
        - Example
    - [`project_scripts`](#project_scripts)
        - Example
    - [`provision_privileged_scripts`](#provision_privileged_scripts)
        - Example
    - [`provision_scripts`](#provision_scripts)
        - Example
    - [`synced_folders`](#synced_folders)
        - Example

## Requirements
- Basic understanding of virtualization, networking, and VMs;
- [Vagrant](https://www.vagrantup.com/downloads.html) >=2.2.0
- [VirtualBox](https://www.virtualbox.org/) >=5.2. While this setup may work with other hypervisors, it has not been tested against them and support is not provided for them;

## Technologies Provided
This repository provides support for the following technologies via a [provisioning shell script](#provision_privileged_scripts) in a `CentOS 7` distribution:

- [Apache](https://github.com/thtg88/vagrant-setup/blob/master/scripts/apache/apache.sh): stock version from `CentOS 7` repository;
- [Apache latest](https://github.com/thtg88/vagrant-setup/blob/master/scripts/apache/http-2.sh): from [CodeIT](https://repo.codeit.guru/packages/centos/7/x86_64/) repository;
- [Apache (with Passenger module)](https://github.com/thtg88/vagrant-setup/blob/master/scripts/apache/apache-passenger.sh): Phusion Passenger Apache module to serve Ruby apps;
- [Composer](https://github.com/thtg88/vagrant-setup/blob/master/scripts/php/composer.sh): PHP dependency management;
- [MariaDB](https://github.com/thtg88/vagrant-setup/blob/master/scripts/mariadb.sh): stock version from `CentOS 7` repository;
- [MongoDB v3.6](https://github.com/thtg88/vagrant-setup/blob/master/scripts/mongodb-3-6.sh);
- [Microsoft SQL Server](https://github.com/thtg88/vagrant-setup/blob/master/scripts/sql-server.sh);
- PHP
    - [5.4](https://github.com/thtg88/vagrant-setup/blob/master/scripts/php/5-4.sh) stock version from `CentOS 7` repository;
    - [5.5](https://github.com/thtg88/vagrant-setup/blob/master/scripts/php/5-5.sh), [5.6](https://github.com/thtg88/vagrant-setup/blob/master/scripts/php/5-6.sh), [7.1](https://github.com/thtg88/vagrant-setup/blob/master/scripts/php/7-1.sh), [7.2](https://github.com/thtg88/vagrant-setup/blob/master/scripts/php/7-2.sh) from [Webtatic](https://webtatic.com/packages/php72/) repository;
- PHP-FPM: [7.1](https://github.com/thtg88/vagrant-setup/blob/master/scripts/php/fpm-7-1.sh), [7.2](https://github.com/thtg88/vagrant-setup/blob/master/scripts/php/fpm-7-2.sh);
- [Ruby](https://github.com/thtg88/vagrant-setup/blob/master/scripts/ruby/ruby.sh): 2.6.3 from RVM, together with `bundler` and `rails` gems;

The [`base.sh`](https://github.com/thtg88/vagrant-setup/blob/master/scripts/base.sh) script will install some basic utilities:
- bind-utils
- epel-release
- git
- nano
- net-tools
- patch
- unzip
- wget
- zip

## Examples
You can find a few examples of Vagrant configurations in the [`examples`](https://github.com/thtg88/vagrant-setup/tree/master/centos-7/examples) folder.

These are all set up on a `CentOS 7` Linux distribution.

Contained in this repository:

- PHP 5.4 with stock Apache, MariaDB, and HTTPS configuration;
- PHP 5.5 with stock Apache, MariaDB, and HTTPS configuration;
- PHP 5.6 with stock Apache and MariaDB:
    - With basic HTTP configuration;
    - Dynamic HTTPS self-signed certificate configuration
- PHP 7.1 with latest Apache from [CodeIT](https://repo.codeit.guru/packages/centos/7/x86_64/) repository, PHP-FPM and MariaDB, together with HTTPS and HTTP/2 configuration out of the box;
- PHP 7.2 with MariaDB, and HTTPS configurationL
    - Latest Apache from [CodeIT](https://repo.codeit.guru/packages/centos/7/x86_64/) repository, PHP-FPM, and MariaDB, together with HTTPS and HTTP/2 configuration out of the box;
    - Stock Apache, and PHP from [Webtatic](https://webtatic.com/packages/php72/) repository
- Ruby 2.6.3 from RVM latest stable, together with Rails, Apache and MariaDB. The Passenger Apache module is used to serve Ruby apps.

## Installation
Make sure you have all the [requirements](#requirements) available before starting.

Clone this repository:
```bash
git clone https://github.com/thtg88/vagrant-setup.git
```

## Usage
From the root folder, create a `config.json` file (you can file an example in [`config.json.example`](https://github.com/thtg88/vagrant-setup/blob/master/config.json.example)), and run:
```bash
vagrant up
```

## Configuration
The `config.json` file can contain the following options:

### `forwarded_ports`
Provides port-mapping from host machine to guest (the actual VM).
It must be an array of objects, with the following attributes:

| Attribute | Type      | Required? | Description |
| --------- | --------- | --------- | ----------- |
| `guest`   | `integer` | Yes       | The guest machine (the VM)'s port to map to |
| `host`    | `integer` | Yes       | The host machine (your computer)'s port to map from |
| `name`    | `string`  | No        | The name given to the single port mapping |

#### Example
```json
{
    "forwarded_ports": [
        {
            "guest": 3306,
            "host": 33060,
            "name": "MariaDB"
        },
        {
            "guest": 80,
            "host": 8800,
            "name": "HTTP"
        },
        {
            "guest": 443,
            "host": 8443,
            "name": "HTTPS"
        }
    ]
}
```

Will map to:

| Name  | VM port | Your computer's port |
| ----- | ------- | -------------------- |
| MySQL | 3306    | 33060                |
| HTTP  | 80      | 8800                 |
| HTTPS | 443     | 8443                 |

And means you will have to access a given web app residing on your VM, from your machine's browser using something like:
```
http://app.localhost:8800
```

### `projects`
An array of projects you would want to have accessible via the VM's web server.
It must be an array of objects, each with the following attributes:

| Attribute       | Type      | Required? | Description |
| --------------- | --------- | --------- | ----------- |
| `database`      | `object`  | No        | A configuration object for the database associated to the project. If configured, will allow to backup the project's database once the VM gets destroyed via `vagrant destroy`. See [`database` backup configuration](#database-backup-configuration). |
| `name`          | `string`  | Yes       | The name of the project. Must be the name of the folder, if using a web server to serve the project from it. |
| `synced_folder` | `object`  | Yes       | A configuration object mapping folders from the host machine to the guest one. See [`synced_folder` configuration](#synced_folder-configuration). |

#### `database` Backup Configuration

| Attribute        | Type      | Required? | Description |
| ---------------- | --------- | --------- | ----------- |
| `backup`         | `boolean` | Yes       | Whether backups are enabled for the database for this project. |
| `guest_folder`   | `string`  | Yes       | The folder on the guest machine (the VM) where to save the database `.sql` backup output. |
| `guest_database` | `object`  | Yes       | An object containing a `name` (the database on the VM you want to back up), a `user` object, containing a `username` and `password`, used to connect to `MySQL` to back up the database.  |

#### `synced_folder` Configuration

| Attribute | Type     | Required? | Description |
| --------- | -------- | --------- | ----------- |
| `guest`   | `string` | Yes       | The folder where to locate the project on the guest machine (your VM). |
| `host`    | `string` | Yes       | The folder where to locate the project on your local machine. |

#### Example
```json
{
    "projects": [
        {
            "database": {
                "backup": true,
                "guest_folder": "/var/www/vhosts/api.acme.com/.mysql_backups",
                "guest_database": {
                    "name": "database_name",
                    "user": {
                        "username": "root",
                        "password": "root"
                    }
                }
            },
            "name": "api.acme.com",
            "synced_folder": {
                "guest": "/var/www/vhosts/api.acme.com",
                "host": "~/Documents/web-projects/api.acme.com"
            }
        }
    ]
}
```

### `project_scripts`
A list of shell scripts to execute for each of the projects.

The path is relative to the [`scripts`](https://github.com/thtg88/vagrant-setup/tree/master/scripts) folder.

#### Example
```json
{
    "project_scripts": [
        "apache/vhost/http-2-php-fpm.sh",
        "apache/vhost/ssl-certificate.sh"
    ]
}
```

### `provision_privileged_scripts`
A list of shell scripts to execute with elevated privileges when provisioning the guest machine (your VM).

The path is relative to the [`scripts`](https://github.com/thtg88/vagrant-setup/tree/master/scripts) folder.

#### Example
```json
{
    "provision_privileged_scripts": [
        "base.sh",
        "apache/http-2.sh",
        "php/fpm-7-2.sh",
        "mariadb.sh"
    ]
}
```

## `provision_scripts`
A list of shell scripts to execute when provisioning the guest machine (your VM).

The path is relative to the [`scripts`](https://github.com/thtg88/vagrant-setup/tree/master/scripts) folder.

#### Example
```json
{
    "provision_scripts": [
        "php/composer.sh",
    ]
}
```

### `synced_folders`
An array of objects, indicating additional folders you want to synchronise with the guest machine (the VM).

Every object supports the following:

| Attribute  | Type     | Required? | Description |
| ---------- | -------- | --------- | ----------- |
| `guest`    | `string` | Yes       | The destination folder on the guest machine (the VM). |
| `host`     | `string` | Yes       | The source folder on the host machine (your computer). |
| `disabled` | `string` | No        | Whether to disable synchronising the folder or not. |

#### Example
```json
{
    "synced_folders": [
        {
            "guest": "/vagrant",
            "host": ".",
            "disabled": true
        },
        {
            "guest": "/opt/library",
            "host": "~/Documents/web-projects/library"
        }
    ]
}
```
