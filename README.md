# Laravel Docker

Nginx & PHP 7 web server.

[View On Github](https://github.com/agweria/laravel-docker)
[View Image](https://hub.docker.com/r/agweria/laravel-docker)
[![DockerHub](https://img.shields.io/docker/pulls/agweria/laravel-docker.svg)](https://hub.docker.com/r/agweria/laravel-docker)


## Build

This includes:
- Alpine 3.11
- PHP 7.4
- NGINX 1.17
- Supervisord
- Composer



# Laravel Application - Quick Run

Using the Laravel installer you can get up and running with a Laravel application inside Docker in minutes.

- Create a new Laravel application `$ laravel new app`
- Change to the applications directory `$ cd app`
- Start the container and attach the application. `$ docker run -d -p 8080:80 --name=testapp -v $PWD:/var/www agweria/laravel-docker`
- Visit the Docker container URL like [http://0.0.0.0:8080](http://0.0.0.0:8080).

### Args

Here are some args

- `NGINX_HTTP_PORT` - HTTP port. Default: `80`.
- `NGINX_HTTPS_PORT` - HTTPS port. Default: `443`.
- `PHP_VERSION` - The PHP version to install. Supports: `7.4,7.3,7.2,7.1`. Default: `7.4`.
- `ALPINE_VERSION` - The Alpine version. Supports: `3.10`. Default: `3.10`.

### Environment Variables

Here are some configurable environment values.

- `WEBROOT` – Path to the web root. Default: `/var/www`
- `WEBROOT_PUBLIC` – Path to the web root. Default: `/var/www/public`
- `COMPOSER_DIRECTORY` - Path to the `composer.json` containing directory. Default: `/var/www`.
- `COMPOSER_UPDATE_ON_BUILD` - Should `composer update` run on build. Default: `0`.
- `RUN_SCHEDULER` - Should the Laravel scheduler command run. Default: `0`.
- `RUN_MIGRATIONS` - Should the migrate command run during build. Default: `0`.
- `GENERATE_PASSPORT_KEYS` - Should the system generate passport keys  [see documentation](https://laravel.com/docs/7.x/passport#deploying-passport)
- `PRODUCTION` – Is this a production environment. Default: `1`
- `PHP_MEMORY_LIMIT` - PHP memory limit. Default: `128M`
- `PHP_POST_MAX_SIZE` - Maximum POST size. Default: `50M`
- `PHP_UPLOAD_MAX_FILESIZE` - Maximum file upload file. Default: `40M`.



### Enabling Laravel queues

To enable laravel queues just set environment `ENABLE QUEUES` to `1` 

### Enable Laravel horizon queue

To enable laravel horizon queue just set environment `START_HORIZON` to `1`. See [documentation](https://laravel.com/docs/7.x/horizon#running-horizon)