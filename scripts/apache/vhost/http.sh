#!/usr/bin/env bash

# Add Apache vhost conf file if N/A
# with HTTP-only support

if [ ! -f /etc/httpd/sites-available/$1.conf ]
then
	echo Creating Apache configuration file for $1...

	# Create .conf file
	cat > /etc/httpd/sites-available/$1.conf <<EOF
<VirtualHost *:80>
	DocumentRoot "/var/www/vhosts/$1/public"
	ServerName $1.localhost
	<Directory "/var/www/vhosts/$1/public">
		Options -Indexes +FollowSymLinks +MultiViews
		AllowOverride All
		Order allow,deny
		allow from all
		# This prevents assets (CSS, JavaScript, images) caching issues
		EnableSendfile Off
	</Directory>
	IndexOptions
	DirectoryIndex index.php index.html
</VirtualHost>
EOF

	# Create symlink in sites-enabled
	ln -sf /etc/httpd/sites-available/$1.conf /etc/httpd/sites-enabled
else
	echo Apache configuration file for $1 already exists - skipping...
fi
