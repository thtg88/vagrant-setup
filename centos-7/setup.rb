# Main Setup Class
class Setup
    def self.configure(config, settings)
        # Configure Local Variable To Access Scripts
        scripts_dir = File.expand_path(File.dirname(__FILE__)) + '/scripts'

        # Every Vagrant development environment requires a box. You can search for
    	# boxes at https://atlas.hashicorp.com/search.
    	config.vm.box = "centos/7"

    	# Create a forwarded port mapping which allows access to a specific port
    	# within the machine from a port on the host machine.
    	if settings.has_key?('forwarded_ports')
    		settings['forwarded_ports'].each do |forwarded_port|
    			if forwarded_port.has_key?('guest') && forwarded_port.has_key?('host')
    				config.vm.network "forwarded_port", guest: forwarded_port['guest'], host: forwarded_port['host']
    			end
    		end
    	end

    	# Enable provisioning with a shell script. Additional provisioners such as
    	# Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
    	# documentation for more information about their specific syntax and use.
        if settings.has_key?('provision_scripts')
            settings['provision_scripts'].each do |provision_script|
                config.vm.provision "shell", path: scripts_dir+"/"+provision_script
            end
        end

    	# Share an additional folder to the guest VM. The first argument is
    	# the path on the host to the actual folder. The second argument is
    	# the path on the guest to mount the folder. And the optional third
    	# argument is a set of non-required options.
    	if settings.has_key?('synced_folders')
    		settings['synced_folders'].each do |synced_folder|
    			if synced_folder.has_key?('guest') && synced_folder.has_key?('host')
    				if synced_folder.has_key?('disabled') && synced_folder['disabled']
    					config.vm.synced_folder synced_folder['host'], synced_folder['guest'], disabled: true
    				else
    					config.vm.synced_folder synced_folder['host'], synced_folder['guest']
    				end
    			end
    		end
    	end

    	if settings.has_key?('projects')
    		settings['projects'].each do |project|
    			if project.has_key?('synced_folder') && project['synced_folder'].has_key?('guest') && project['synced_folder'].has_key?('host')
    				# Shares a folder for each project
    				config.vm.synced_folder project['synced_folder']['host'], project['synced_folder']['guest']
    			end

    			if project.has_key?('name')
    				# Creates Apache configuration files if N/A
    				config.vm.provision "shell", path: scripts_dir+'/apache/vhost/http-https.sh', run: "always" do |s|
    					s.args = [project['name']]
    				end

    				# Creates SSL config if N/A
    				config.vm.provision "shell", path: scripts_dir+'/apache/vhost/ssl-certificate.sh', run: "always" do |s|
    					s.args = [project['name']]
    				end
    			end

                # Database backup configuration
                if !project.has_key?('database')
                    next
                end
                if !project['database'].has_key?('backup') || !project['database']['backup'] || !project['database'].has_key?('guest_folder') || !project['database']['guest_folder']
                    next
                end
                if !project['database'].has_key?('guest_database')
                    next
                end
                if !project['database']['guest_database'].has_key?('name') || !project['database']['guest_database']['name']
                    next
                end
                if !project['database']['guest_database'].has_key?('user')
                    next
                end
                if !project['database']['guest_database']['user'].has_key?('username') || !project['database']['guest_database']['user']['username']
                    next
                end
                if !project['database']['guest_database']['user'].has_key?('password') || !project['database']['guest_database']['user']['password']
                    next
                end

                guest_folder = project['database']['guest_folder']
                database_name = project['database']['guest_database']['name']
                username = project['database']['guest_database']['user']['username']
                password = project['database']['guest_database']['user']['password']
                Setup.backup_mysql(config, database_name, username, password, guest_folder)
    		end
    	end

    	# Restart Apache
    	config.vm.provision "shell", inline: 'systemctl restart httpd.service', run: "always"
    end

    def self.backup_mysql(config, database, username, password, dir)
        if Vagrant::VERSION < '2.1.0' && !Vagrant.has_plugin?('vagrant-triggers')
            abort "You must have Vagrant version 2.1.0 or higher, or the vagrant-triggers plugin in order to proceed"
        end
        now = Time.now.strftime("%Y-%m-%dT%H-%M-%S")
        config.trigger.before :destroy do |trigger|
            trigger.warn = "Backing up mysql database #{database}..."
            trigger.run_remote = {
                inline: "mkdir -p #{dir} && mysqldump --user=#{username} --password=#{password} --routines #{database} > #{dir}/#{database}-#{now}.sql"
            }
        end
    end
end
