FROM alpine:3.21
RUN apk add --no-cache php-fpm curl ca-certificates php-mysqli php-json php-redis su-exec

RUN mkdir -p /run/php && \
    chmod 777 /run/php
	#TODO: adjust permissions

COPY ./conf/fpm-pool.conf /etc/php/7.4/fpm/pool.d/fpm-pool.conf

COPY --chmod=500 ./tools/init.sh /root/init.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT [ "/root/init.sh" ]
# CMD [ "php-fpm7.4", "-F" ]
CMD ["tail", "-f", "/dev/null"]