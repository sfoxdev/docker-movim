#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

FROM phusion/baseimage:0.9.19
MAINTAINER SFox Lviv <sfox.lviv@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive RUNLEVEL=1

#ADD install.sh /install.sh
#RUN /install.sh && rm /install.sh

RUN apt-get update\
    && apt-get install -y apt-utils mc wget php php-curl php-imagick php-gd php-mysql php-zip php-mbstring php-fpm php-xml git locales sudo nginx supervisor

RUN mkdir -p /var/www/html \
    && chown -R www-data /var/www/html \
    && chown -R www-data /var/lib/nginx \
    && mkdir -p /var/www/.composer \
    && chown -R www-data /var/www/.composer \
    && gpasswd -a www-data sudo \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /var/www/html

#COPY conf /

RUN rm index.nginx-debian.html \
    && git clone https://github.com/movim/movim.git . \
    && cp config/db.example.inc.php config/db.inc.php \
    && wget -qO- https://getcomposer.org/installer | php \
    && php composer.phar install \
    && chown -R www-data /var/www/html

VOLUME ["/var/www/html/log/","/var/www/html/users/","/var/www/html/cache/"]


RUN sed -i 's/user\s*nginx;/user www-data;/' /etc/nginx/nginx.conf \
        && rm /etc/php/7.0/fpm/pool.d/*
COPY conf/etc/php/7.0/fpm/pool.d/php-fpm-movim.conf /etc/php/7.0/fpm/pool.d/php-fpm-movim.conf
COPY conf/etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf
COPY conf/etc/nginx/nginx.conf /etc/nginx/nginx.conf
COPY conf/configure-script /configure-script
COPY conf/etc/supervisor/conf.d/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY conf/var/www/html/config/db.inc.php /var/www/html/config/db.inc.php
RUN chown www-data:www-data /var/www/html/config/db.inc.php

#    && nginx -t \
#    && php-fpm7.0 -t

EXPOSE 80 8080 8170

CMD supervisord -c /etc/supervisor/conf.d/supervisord.conf
