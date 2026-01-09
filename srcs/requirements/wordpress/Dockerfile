FROM alpine:3.21
RUN apk add --no-cache \
	curl \
	ca-certificates \
	php83 \
    php83-fpm \
    php83-phar \
    php83-mysqli \
    php83-json \
    php83-curl \
    php83-xml \
    php83-zip \
    php83-mbstring \
    php83-opcache \
    php83-session
	# php83-redis | TODO: Bonus

COPY ./conf/fpm-pool.conf /etc/php/8.3/fpm/pool.d/fpm-pool.conf
COPY --chmod=555 ./tools/init.sh /etc/init.sh

RUN adduser -u 82 -D -S -G www-data www-data

RUN mkdir -p /run/php \
	&& chown -R www-data:www-data /run/php \
	&& chmod -R 644 /run/php

RUN mkdir -p /var/www/html \
	&& chown -R www-data:www-data /var/www/html \
	&& chmod -R 644 /var/www/html

RUN curl -fsSL -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && \
	mv wp-cli.phar /usr/local/bin/wp

USER www-data
WORKDIR /var/www/html
EXPOSE 9000

ENTRYPOINT [ "/etc/init.sh" ]
CMD [ "php-fpm83", "-F" ]
# CMD ["tail", "-f", "/dev/null"]