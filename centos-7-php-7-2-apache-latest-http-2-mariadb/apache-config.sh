if [ ! -f /etc/httpd/sites-available/$1.conf ]
then
    echo Creating Apache configuration file for $1...
    # Create .conf file
    cat > /etc/httpd/sites-available/$1.conf <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/vhosts/$1"
    ServerName $1.localhost
    <Directory "/var/www/vhosts/$1">
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
<VirtualHost *:443>
    Protocols h2 http/1.1
    DocumentRoot "/var/www/vhosts/$1"
    ServerName $1.localhost
    <Directory "/var/www/vhosts/$1">
        Options -Indexes +FollowSymLinks +MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
        # This prevents assets (CSS, JavaScript, images) caching issues
        EnableSendfile Off
    </Directory>
    IndexOptions
    DirectoryIndex index.php index.html
    ProxyPassMatch ^/(.*\.php)$ fcgi://127.0.0.1:9000/var/www/vhosts/$1/\$1
    SSLEngine on
    SSLCertificateFile "/var/www/certificates/$1.localhost.crt"
    SSLCertificateKeyFile "/var/www/certificates/$1.localhost.key"
</VirtualHost>
EOF
    # Create symlink
    ln -sf /etc/httpd/sites-available/$1.conf /etc/httpd/sites-enabled
else
    echo Apache configuration file for $1 already exists - skipping...
fi
