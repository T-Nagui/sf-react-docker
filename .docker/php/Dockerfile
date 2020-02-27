FROM php:7.4-fpm
MAINTAINER Neji Trabelsi <tni.nagui@gmail.com>

#pour activer ou non le Xdebug depuis docker compose
ARG WITH_XDEBUG=false

RUN apt-get update && apt-get install -y --no-install-recommends \
    nano curl debconf subversion \
    git apt-transport-https apt-utils \
    build-essential locales acl mailutils \
    wget zip unzip gnupg gnupg1 gnupg2 ssh \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
    #pecl install mongodb \



RUN apt-get install -y libzip-dev zlib1g-dev

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

# RUN curl -sSk https://getcomposer.org/installer | php -- --disable-tls \
#    && mv composer.phar /usr/local/bin/composer

#RUN composer global require hirak/prestissimo --prefer-dist --no-progress --no-suggest --classmap-authoritative

RUN chown -R www-data:www-data /.composer

RUN rm -rf /var/lib/apt/lists/*
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen
ADD . /var/www
RUN chown -R www-data:www-data /var/www

WORKDIR /var/www/

ENV PATH="~/.composer/vendor/bin:./vendor/bin:${PATH}"

EXPOSE 9000
CMD ["php-fpm"]