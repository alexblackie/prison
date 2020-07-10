FROM alpine:3.12

RUN apk add --no-cache --update \
    rsync curl \
    apache2 apache2-utils apache2-http2 \
    php7-apache2 \
    php7-cli \
    php7-phar \
    php7-zlib \
    php7-zip \
    php7-bz2 \
    php7-ctype \
    php7-curl \
    php7-pdo_mysql \
    php7-pdo_pgsql \
    php7-mysqli \
    php7-pgsql \
    php7-json \
    php7-mcrypt \
    php7-xml \
    php7-dom \
    php7-iconv \
    php7-session \
    php7-intl \
    php7-gd \
    php7-mbstring \
    php7-opcache \
    php7-tokenizer \
    php7-simplexml

ADD ./httpd.conf /etc/apache2/httpd.conf

ADD ./prison-update-source /usr/bin/prison-update-source
ADD ./prison-start /usr/bin/prison-start
RUN chmod +x /usr/bin/prison-update-source /usr/bin/prison-start

CMD ["/usr/bin/prison-start"]
