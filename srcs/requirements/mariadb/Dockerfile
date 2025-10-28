FROM alpine:3.21
RUN apk add --no-cache mariadb mariadb-client su-exec
COPY ./conf/db.conf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY --chmod=555 ./tools/init.sh /etc/init.sh
RUN mkdir -p /run/mysqld && \
	chown -R mysql:mysql /run/mysqld && \
	chmod 755 /run/mysqld
ENTRYPOINT [ "/etc/init.sh" ]
CMD [ "mariadbd" ]