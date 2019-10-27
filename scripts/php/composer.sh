#!/usr/bin/env bash

# Install Composer

EXPECTED_SIGNATURE=$(wget https://composer.github.io/installer.sig -O - -q)
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")
if [ "$EXPECTED_SIGNATURE" = "$ACTUAL_SIGNATURE" ]
then
    php composer-setup.php --quiet
    mv composer.phar /usr/local/bin/composer
else
    >&2 echo 'ERROR: Invalid installer signature'
fi
rm composer-setup.php
