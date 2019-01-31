##############################################################
# Arguments to build
##############################################################

ARG WORKSPACE_COMPOSER_VERSION
ARG WORKSPACE_NODE_VERSION
ARG WORKSPACE_PHP_VERSION

#####################################################################
# Composer: Official Image
#####################################################################

FROM composer:${WORKSPACE_COMPOSER_VERSION} as composer

#####################################################################
# Node: Official Image
#####################################################################

FROM node:${WORKSPACE_NODE_VERSION} as node

#####################################################################
# PHP: Official Image
#####################################################################

FROM php:${WORKSPACE_PHP_VERSION}

LABEL maintainer="Alley M. Carvalho <alleycarvalho@gmail.com>"

# Copy the Composer PHAR into the PHP image
COPY --from=composer /usr/bin/composer /usr/bin/composer
# Copy of the Node Image into the PHP image
COPY --from=node . .

# Start as root
USER root

#####################################################################
# Prevent files being created with root permissions on host machine.
# Infradocker non-root user:
#####################################################################

ARG PUID=1000
ENV PUID ${PUID}
ARG PGID=1000
ENV PGID ${PGID}

#####################################################################
# Set Timezone:
#####################################################################

ARG TZ=UTC
ENV TZ ${TZ}

#####################################################################
# RUN Setup:
#####################################################################

ARG INSTALL_NPM_VUE_CLI=false

RUN apk update && apk upgrade \
    && apk add --no-cache --virtual .build-deps \
        shadow \
    && groupmod -g 1001 node \
    && usermod -u 1001 node \
    && npm install -g npm@latest \
    && if [ ${INSTALL_NPM_VUE_CLI} = true ]; then \
        npm install -g @vue/cli \
    ;fi \
    && apk del .build-deps \
    # Add a non-root user
    && addgroup -g ${PGID} -S infradocker \
    && adduser -u ${PUID} -D -S -G infradocker infradocker \
    # Install dependencies, softwares, etc.
    && apk add --no-cache --virtual .persistent-deps \
        bash \
        git \
        openssh \
        tzdata \
        vim \
    # PHP dependencies
    && docker-php-ext-install \
        mysqli \
        pdo_mysql \
    # Set Timezone
    && cp /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo ${TZ} > /etc/timezone \
    && apk del tzdata \
    # Remove cache
    && rm -rf /tmp/* /var/cache/apk/*

#####################################################################
# User Aliases:
#####################################################################

COPY ./aliases.sh /root/aliases.sh
COPY ./aliases.sh /home/infradocker/aliases.sh

RUN sed -i 's/\r//' /root/aliases.sh \
    && sed -i 's/\r//' /home/infradocker/aliases.sh \
    && chown infradocker:infradocker /home/infradocker/aliases.sh \
    && echo "# Load Custom Aliases" >> ~/.bashrc \
    && echo "source ~/aliases.sh" >> ~/.bashrc \
    && echo "" >> ~/.bashrc

USER infradocker

ARG APP_LARAVEL_PATH=/var/www
ENV APP_LARAVEL_PATH ${APP_LARAVEL_PATH}

RUN echo "# Load Custom Aliases" >> ~/.bashrc \
    && echo "source ~/aliases.sh" >> ~/.bashrc \
    && echo "" >> ~/.bashrc \
    # Add ./vendor/bin to non-root user's bashrc (needed for phpunit)
    && echo 'export PATH="$APP_LARAVEL_PATH/vendor/bin:$PATH"' >> ~/.bashrc \
    && echo "" >> ~/.bashrc

#####################################################################
# Git Settings:
#####################################################################

ARG GIT_EMAIL=
ENV GIT_EMAIL ${GIT_EMAIL}
ARG GIT_NAME=
ENV GIT_NAME ${GIT_NAME}

RUN git config --global user.name "$GIT_NAME" \
    && git config --global user.email $GIT_EMAIL \
    && git config --global color.ui true \
    && git config --list

#####################################################################
# Final:
#####################################################################

USER infradocker

ARG INSTALL_NPM_VUE_CLI=false

RUN printf "\n\033[1;36mDate:\033[0m\n" \
    && date \
    && printf "\n\033[1;36mCheck Composer Version:\033[0m\n" \
    && composer --version \
    && printf "\n\033[1;36mCheck PHP Version:\033[0m\n" \
    && php -v \
    && printf "\n\033[1;36mCheck Node Version:\033[0m\n" \
    && node -v \
    && printf "\n\033[1;36mCheck Npm Version:\033[0m\n" \
    && npm -v \
    && if [ ${INSTALL_NPM_VUE_CLI} = true ]; then \
        printf "\n\033[1;36mCheck Vue Cli Version:\033[0m\n" \
        && vue --version \
    ;fi \
    && printf "\n\033[1;36mCheck Yarn Version:\033[0m\n" \
    && yarn -v \
    && printf "\n"

# Set default work directory
WORKDIR /var/www

CMD ["/bin/bash"]
