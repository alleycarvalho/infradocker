FROM nginx:alpine

LABEL maintainer="Alley M. Carvalho <alleycarvalho@gmail.com>"

COPY nginx.conf /etc/nginx/

RUN apk update && apk upgrade && \
    apk --no-cache add \
    bash \
    openssl \
    && \
    adduser -D -H -u 1000 -s /bin/bash www-data

ARG PHP_UPSTREAM_CONTAINER=php-fpm
ARG PHP_UPSTREAM_PORT=9000

# Set upstream conf and remove the default conf
RUN echo "upstream php-upstream { server ${PHP_UPSTREAM_CONTAINER}:${PHP_UPSTREAM_PORT}; }" > /etc/nginx/conf.d/upstream.conf \
    && rm /etc/nginx/conf.d/default.conf

ADD ./startup.sh /opt/startup.sh

CMD ["/bin/bash", "/opt/startup.sh"]

EXPOSE 80 443
