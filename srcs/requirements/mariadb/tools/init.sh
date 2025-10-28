#!/bin/sh

intialize_service()
{
	if [ ! -d "/var/lib/mysql/mysql" ]; then
        mariadb-install-db --user=mysql --datadir=/var/lib/mysql
    fi
}

secure_and_init() {
    DATABASE_NAME=$(cat $SECRETS_PREFIX/database_name)
    DATABASE_USER_NAME=$(cat $SECRETS_PREFIX/database_user_name)
    DATABASE_USER_PASSWORD=$(cat $SECRETS_PREFIX/database_user_password)

    su-exec mysql mariadbd --skip-networking --bootstrap <<EOSQL
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS $DATABASE_NAME;
CREATE USER IF NOT EXISTS '$DATABASE_USER_NAME'@'%' IDENTIFIED BY '$DATABASE_USER_PASSWORD';
GRANT ALL ON $DATABASE_NAME.* TO '$DATABASE_USER_NAME'@'%';
FLUSH PRIVILEGES;
EOSQL
}

intialize_service
secure_and_init

exec su-exec mysql "$@"