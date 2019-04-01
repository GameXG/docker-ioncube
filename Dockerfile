FROM php:5.6-apache
MAINTAINER atsu666

# apache user
RUN usermod -u 1000 www-data \
    && groupmod -g 1000 www-data

# extension
RUN apt-get update \
    && apt-get install -y \
        libfreetype6-dev \
        libmagickwand-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        jpegoptim \
        optipng \
        gifsicle \
        sendmail \
        git-core \
        build-essential \
        openssl \
        libssl-dev \
        python2.7 \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install -j$(nproc) zip \
    && docker-php-ext-install mbstring \
    && docker-php-ext-install gettext \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install bcmath \
    && docker-php-ext-enable mysqli \
    && pecl install xdebug-2.6.0 \
        imagick \
    && docker-php-ext-enable xdebug \
    && docker-php-ext-enable imagick \
    && ln -s /usr/bin/python2.7 /usr/bin/python

# ioncube loader
RUN curl -o ioncube.tar.gz "http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz" \
    && mkdir -p ioncube \
    && tar -xf ioncube.tar.gz -C ioncube --strip-components=1 \
    && mv ioncube/ioncube_loader_lin_5.6.so `php-config --extension-dir` \
    && rm -Rf ioncube.tar.gz ioncube \
    && docker-php-ext-enable ioncube_loader_lin_5.6


# composer
RUN curl -S https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && composer self-update

# apache user
RUN usermod -u 1000 www-data \
    && groupmod -g 1000 www-data

CMD ["apache2-foreground"]

