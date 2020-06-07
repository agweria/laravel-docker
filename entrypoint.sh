#!/bin/bash

# UPDATE THE WEBROOT IF REQUIRED.
if [[ -n "${WEBROOT}" ]] && [[ -n "${WEBROOT_PUBLIC}" ]]; then
    sed -i "s#root /var/www/public;#root ${WEBROOT_PUBLIC};#g" /etc/nginx/sites-available/default.conf
else
    export WEBROOT=/var/www
    export WEBROOT_PUBLIC=/var/www/public
fi

# UPDATE COMPOSER PACKAGES ON BUILD.
## 💡 THIS MAY MAKE THE BUILD SLOWER BECAUSE IT HAS TO FETCH PACKAGES.
if [[ -n "${COMPOSER_DIRECTORY}" ]] && [[ "${COMPOSER_UPDATE_ON_BUILD}" == "1" ]]; then
    cd "${COMPOSER_DIRECTORY}"
    composer update && composer dump-autoload -o
fi


# RUN LARAVEL MIGRATIONS ON BUILD.
if [[ "${RUN_MIGRATIONS}" == "1" ]]; then
    cd "${WEBROOT}"
    php artisan migrate --force
fi

# RUN LARAVEL MIGRATIONS ON BUILD.
if [[ "${GENERATE_PASSPORT_KEYS}" == "1" ]]; then
    cd ${WEBROOT}
    php artisan passport:keys
fi
# LARAVEL SCHEDULER
if [[ "${RUN_SCHEDULER}" == "1" ]]; then
    echo '* * * * * cd /var/www && php artisan schedule:run >> /dev/null 2>&1' > /etc/crontabs/root
    crond
fi

# SYMLINK CONFIGURATION FILES.
ln -s /etc/php7/php.ini /etc/php7/conf.d/php.ini
ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf

# PHP & SERVER CONFIGURATIONS.
if [[ -n "${PHP_MEMORY_LIMIT}" ]]; then
    sed -i "s/memory_limit = 128M/memory_limit = ${PHP_MEMORY_LIMIT}M/g" /etc/php7/conf.d/php.ini
fi

if [ -n "${PHP_POST_MAX_SIZE}" ]; then
    sed -i "s/post_max_size = 50M/post_max_size = ${PHP_POST_MAX_SIZE}M/g" /etc/php7/conf.d/php.ini
fi

if [ -n "${PHP_UPLOAD_MAX_FILESIZE}" ]; then
    sed -i "s/upload_max_filesize = 40M/upload_max_filesize = ${PHP_UPLOAD_MAX_FILESIZE}M/g" /etc/php7/conf.d/php.ini
fi


find /etc/php7/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;



# START SUPERVISOR.
if [[ "${ENABLE_QUEUES}" == "1" ]]; then
    echo 'Enabling queues'
    cat /etc/supervisord-queues.conf >> /etc/supervisord.conf
fi

if [[ "${START_HORIZON}" == "1" ]]; then
    echo 'Enabling horizon queues'
    cat /etc/supervisord-horizon.conf >> /etc/supervisord.conf
fi

exec /usr/bin/supervisord -n -c /etc/supervisord.conf