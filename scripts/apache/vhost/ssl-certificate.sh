#!/usr/bin/env bash

# Create self-signed SSL certificate

if [ ! -f /var/www/certificates/$1.localhost.crt ]
then
    echo Creating SSL configuration file for $1...

    # Create certificate .conf file
    cat > /var/www/certificates/$1.localhost.conf <<EOF
[ req ]

default_bits        = 2048
default_keyfile     = server-key.pem
distinguished_name  = subject
req_extensions      = req_ext
x509_extensions     = x509_ext
string_mask         = utf8only

[ subject ]

countryName                 = Country Name (2 letter code)
countryName_default         = GB

stateOrProvinceName         = State or Province Name (full name)
stateOrProvinceName_default = Bristol

localityName                = Locality Name (eg, city)
localityName_default        = Bristol

organizationName            = Organization Name (eg, company)
organizationName_default    = ACME Ltd.

commonName                  = Common Name (e.g. server FQDN or YOUR name)
commonName_default          = $1.localhost

emailAddress                = Email Address
emailAddress_default        = yourname@mail.com

[ x509_ext ]

subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid,issuer

basicConstraints       = CA:FALSE
keyUsage               = digitalSignature, keyEncipherment
subjectAltName         = @alternate_names
nsComment              = "OpenSSL Generated Certificate"

[ req_ext ]

subjectKeyIdentifier = hash

basicConstraints     = CA:FALSE
keyUsage             = digitalSignature, keyEncipherment
subjectAltName       = @alternate_names
nsComment            = "OpenSSL Generated Certificate"

[ alternate_names ]

DNS.1       = $1.localhost
DNS.2       = www.$1.localhost

# These are needed for development.
DNS.3       = localhost
DNS.4       = localhost.localdomain
DNS.5       = 127.0.0.1

# IPv6 localhost
DNS.6     = ::1
EOF

    # Create RSA key
    openssl genrsa -out /var/www/certificates/$1.localhost.key 2048

    # Create SSL certificate from previously generated .conf file
    openssl req -config /var/www/certificates/$1.localhost.conf -new -x509 -key /var/www/certificates/$1.localhost.key -out /var/www/certificates/$1.localhost.crt -days 3650 -subj /CN=$1.localhost
else
    echo SSL configuration file for $1 already exists - skipping...
fi
