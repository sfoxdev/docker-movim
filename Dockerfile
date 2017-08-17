FROM phusion/baseimage:0.9.19
MAINTAINER SFoxDev <admin@sfoxdev.com>

ENV DEBIAN_FRONTEND=noninteractive RUNLEVEL=1 \
  LC_ALL=C.UTF-8 \
  LANG=en_US.UTF-8 \
  LANGUAGE=en_US.UTF-8

RUN apt-get update \
    && apt-get install -y \
    apt-utils mc wget git locales sudo nginx supervisor \
    php php-curl php-imagick php-gd php-mysql php-zip php-mbstring php-fpm php-xml \
    && mkdir -p /var/www/html \
    && chown -R www-data /var/www/html \
    && chown -R www-data /var/lib/nginx \
    && mkdir -p /var/www/.composer \
    && chown -R www-data /var/www/.composer \
    && gpasswd -a www-data sudo \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    && cd /var/www/html \
    && rm index.nginx-debian.html \
    && git clone https://github.com/movim/movim.git . \
    && cp config/db.example.inc.php config/db.inc.php \
    && wget -qO- https://getcomposer.org/installer | php \
    && php composer.phar install \
    && chown -R www-data /var/www/html \
    && sed -i 's/user\s*nginx;/user www-data;/' /etc/nginx/nginx.conf \
    && rm /etc/php/7.0/fpm/pool.d/*

ADD conf /

RUN chown www-data:www-data /var/www/html/config/db.inc.php
#    && nginx -t \
#    && php-fpm7.0 -t

WORKDIR /var/www/html

VOLUME ["/var/www/html/log/","/var/www/html/users/","/var/www/html/cache/"]

EXPOSE 80 8080 8170

CMD supervisord -c /etc/supervisor/conf.d/supervisord.conf
