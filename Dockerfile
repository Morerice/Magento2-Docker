FROM php:7.4-apache
LABEL maintainer="Ata Berk YILMAZ <me@ataberkylmz.com>"

ENV MAGENTO_HOST=192.168.1.187 \
DB_SERVER=mysql \
DB_NAME=magento \
DB_USER=magento \
DB_PASSWORD=magento \
DB_PREFIX=m2 \
ADMIN_NAME=Ata \
ADMIN_LASTNAME=Yilmaz \
ADMIN_EMAIL=me@ataberkylmz.com \
ADMIN_USERNAME=admin \
ADMIN_PASSWORD=admin123 \
ADMIN_URLEXT=admin \
MAGENTO_LANGUAGE=en_US \
MAGENTO_CURRENCY=EUR \
MAGENTO_TZ=Europe/Amsterdam

RUN echo "ServerName $MAGENTO_HOST" >> /etc/apache2/apache2.conf

RUN apt-get update \
	&& apt-get install -y libjpeg62-turbo-dev \
		libpng-dev \
		libfreetype6-dev \
		libxml2-dev \
		libzip-dev \
		libssl-dev \
		libxslt-dev \
		default-mysql-client \
		wget \
    unzip 

RUN docker-php-ext-configure gd --with-freetype --with-jpeg
RUN docker-php-ext-install -j$(nproc) bcmath gd intl pdo_mysql simplexml soap sockets xsl zip

RUN echo "<?php phpinfo(); ?>" > index.php

COPY config/php.ini /usr/local/etc/php/
COPY config/install_magento.sh install_magento.sh

ADD https://github.com/magento/magento2/archive/refs/tags/2.4.2.tar.gz magento.tar.gz

EXPOSE 80
