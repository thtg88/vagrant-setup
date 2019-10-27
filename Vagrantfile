# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'json'

confDir = File.expand_path(File.dirname(__FILE__))
configPath = confDir + "/config.json"

require File.expand_path(File.dirname(__FILE__) + '/setup.rb')

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
	# The most common configuration options are documented and commented below.
	# For a complete reference, please see the online documentation at
	# https://docs.vagrantup.com.

	# Open JSON configuration file
	if File.exist? configPath then
		settings = JSON::parse(File.read(configPath))
	else
		abort "Config settings file not found in #{confDir}"
	end

	Setup.configure(config, settings)
end
