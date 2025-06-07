FROM php:8.3-fpm-alpine AS build

# System dependencies
RUN apk add --no-cache \
    git unzip curl icu-dev postgresql-dev oniguruma-dev \
 && docker-php-ext-install intl pdo_pgsql opcache

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /app

COPY symfony-app/ ./

# Install ALL dependencies (including dev) to get DebugBundle
RUN composer install --optimize-autoloader --no-interaction

FROM php:8.3-fpm-alpine AS final

RUN adduser -D symfony

WORKDIR /var/www/html

COPY --from=build /app /var/www/html

USER symfony

EXPOSE 9000

CMD ["php-fpm"]