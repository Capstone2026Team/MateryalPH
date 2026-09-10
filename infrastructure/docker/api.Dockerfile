FROM php:8.4-cli-alpine

RUN apk upgrade --no-cache \
    && apk add --no-cache \
        autoconf \
        g++ \
        git \
        icu-dev \
        libzip-dev \
        linux-headers \
        make \
        postgresql-dev \
    && docker-php-ext-install bcmath intl opcache pcntl pdo_pgsql zip \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del autoconf g++ linux-headers make

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /workspace/services/api
