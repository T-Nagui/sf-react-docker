FROM php:7.4-fpm
MAINTAINER Neji Trabelsi <tni.nagui@gmail.com>

#pour activer ou non le Xdebug depuis docker compose
ARG WITH_XDEBUG=false

RUN apt-get update && apt-get install -y --no-install-recommends nano curl debconf subversion libzip-dev zlib1g-dev \
    && apt-get install -y apt-transport-https apt-utils build-essential locales acl mailutils wget zip unzip gnupg gnupg1 gnupg2 ssh \
    && apt-get install -y curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install git
RUN apt-get update \
    && apt-get -y install git zip unzip \
    && apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN if [ $WITH_XDEBUG = "true" ] ; then \
    pecl install xdebug; \
    docker-php-ext-enable xdebug; \
    echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "display_startup_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
    fi ;

RUN docker-php-ext-install pdo pdo_mysql

COPY php-fpm-pool.conf /etc/php/7.4/pool.d/www.conf

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer
RUN ln -snf /usr/share/zoneinfo/Europe/Lisbon /etc/localtime

ADD . /var/www
RUN chown -R www-data:www-data /var/www

WORKDIR /var/www/

#ENV PATH="~/.composer/vendor/bin:./vendor/bin:${PATH}"

EXPOSE 9000
CMD ["php-fpm"]
