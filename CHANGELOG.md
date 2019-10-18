# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/) (or at least it tries to).

## Unreleased
### Added
- Choose PHP version
- Choose provisioning script(s)
- Choose box to provision
- Clear vhosts (perhaps only unused ones)
- Configure cron jobs
- Copy database from remote server
- Create database if it does not exist
- Domain to /etc/hosts file on host machine (https://github.com/cogitatio/vagrant-hostsupdater)
- Support for public and private SSH keys
- Update Composer On Every Provision
### Changed
- Isolate configuration in Ruby class

## [3.2.0] - 2019-10-18
### Added
- PHP 5.4 setup (with HTTPS)

## [3.1.3] - 2019-07-14
### Fixed
- **[Ruby]**: Passenger configuration for development environment
### Removed
- **[Ruby]**: MariaDB support

## [3.1.2] - 2019-07-14
### Changed
- **[Ruby]**: Now Ruby is installed globally
- **[Ruby]**: General improvements and bug fixes

## [3.1.1] - 2019-07-14
### Added
- **[Ruby]**: mod_ssl to Ruby VM provisioning
### Changed
- **[Ruby]**: Locked version installed to 2.6.3
### Fixed
- **[Ruby]**: Passenger configuration
### Removed
- **[Ruby]**: Apache HTTP/2 support

## [3.1.0] - 2019-07-14
### Added
- **[Ruby]**: Basic Ruby configuration with RVM and Rails support

## [3.0.0] - 2019-07-10
### Removed
- Support for CentOS's default NodeJS installation (v6.x)

## [2.2.2] - 2019-05-19
### Changed
- Use current directory instead of absolute one for scripts

## [2.2.1] - 2019-05-19
### Changed
- Error message about triggers

## [2.2.0] - 2019-05-18
### Added
- Ability to backup databases from config before destroy

## [2.1.0] - 2019-05-18
### Added
- Standard PHP 7.2 setup (without HTTP/2)

## [2.0.2] - 2019-05-18
### Fixed
- Import after directory re-structure

## [2.0.1] - 2019-05-18
### Changed
- Folder re-structuring

## [2.0.0] - 2019-05-05
### Changed
- Settings are now based on config.json file

## [1.2.0] - 2019-05-05
### Changed
- Renamed vm-bootstrap.sh to vm-provision.sh

## [1.1.0] - 2019-05-05
### Added
- MySQL initial setup in provision

## [1.0.0] - 2019-05-05
### Added
- Initial release
