FROM alpine:3.21
RUN apk add --no-cache mariadb mariadb-client su-exec

COPY ./conf/db.conf /etc/my.cnf.d/server.cnf

COPY --chmod=755 ./tools/init.sh /etc/init.sh

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld
EXPOSE 3306

ENTRYPOINT [ "/etc/init.sh" ]