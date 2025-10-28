FROM alpine:3.21
RUN apk add --no-cache nginx openssl
# COPY ./conf/nginx.conf /etc/nginx/nginx.conf
# COPY ./conf/default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80 443
WORKDIR /var/www/html
CMD ["nginx", "-g", "daemon off;"]