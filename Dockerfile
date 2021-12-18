FROM php:8.1-cli-alpine

# run update
RUN apk upgrade && apk update

# install build dependencies
RUN apk add --no-cache --virtual .build-deps \
  $PHPIZE_DEPS

# install application framework php extensions
RUN docker-php-ext-install \
  bcmath

# install xdebug
RUN pecl install xdebug-3.1.2 \
  && docker-php-ext-enable xdebug \
  && echo "xdebug.mode=debug" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.start_with_request=trigger" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.remote_handler=dbgp" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.client_port=9000" >> $PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini

# install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# install NPM# install nodejs and npm
RUN apk add --no-cache nodejs npm

# uninstall build dependencies
RUN apk del -f .build-deps

# modify user id for www-data to 1001
RUN apk --no-cache add shadow && usermod -u 1001 www-data
