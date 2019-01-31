##############################################################
# Arguments to build
##############################################################

ARG PHP_FPM_VERSION

#####################################################################
# PHP: Official Image
#####################################################################

FROM php:${PHP_FPM_VERSION}

LABEL maintainer="Alley M. Carvalho <alleycarvalho@gmail.com>"

#####################################################################
# Infradocker non-root user:
#####################################################################

ARG PUID=1000
ENV PUID ${PUID}
ARG PGID=1000
ENV PGID ${PGID}

#####################################################################
# RUN Setup:
#####################################################################

RUN apk update && apk upgrade \
    # Install dependencies, libraries, etc.
    && apk add --no-cache --virtual .persistent-deps \
        shadow \
    # PHP dependencies
    && docker-php-ext-install \
        pdo_mysql \
    # Change uid for www-data user
    && usermod -u ${PUID} www-data \
    && groupmod -g ${PGID} www-data \
    # Remove cache
    && rm /var/cache/apk/*

#####################################################################
# Final:
#####################################################################

COPY ./laravel.ini /usr/local/etc/php/conf.d
COPY ./xlaravel.pool.conf /usr/local/etc/php-fpm.d/

# Set default work directory
WORKDIR /var/www

CMD ["php-fpm"]

EXPOSE 9000
