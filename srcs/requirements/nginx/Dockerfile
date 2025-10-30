FROM alpine:3.21
RUN apk add --no-cache nginx openssl
RUN unlink /etc/nginx/http.d/default.conf
COPY ./conf/web-server.conf /etc/nginx/http.d/web-server.conf
COPY --chmod=500 ./tools/init.sh /root/
EXPOSE 443
WORKDIR /var/www/html
ENTRYPOINT [ "/root/init.sh" ]
CMD [ "nginx", "-g", "daemon off;" ]
