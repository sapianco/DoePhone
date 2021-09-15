#!/bin/bash
set -e

if [[ -z "${DEV}" ]]; then
  echo "production MODE"
  #cp "$PHP_INI_DIR/php.ini-production" /etc/php7/php-fpm.d/php.ini
else
    echo "dev MODE"
    #cp "$PHP_INI_DIR/php.ini-development" /etc/php7/php-fpm.d/php.ini
    touch /var/www/html/phpinfo.php
    echo '<?php phpinfo(); ?>' >> /var/www/html/phpinfo.php
    echo '<?php (is_array(opcache_get_status()) ? 'enabled' : 'disabled'); ?>' >> /var/www/html/opcache.php
fi

exec "$@"
