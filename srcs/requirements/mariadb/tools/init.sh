#!/bin/sh
set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

if [ -n "$SECRETS_PREFIX" ] && [ -f "$SECRETS_PREFIX/database_name" ]; then
    DATABASE_NAME=$(cat $SECRETS_PREFIX/database_name)
    DATABASE_USER_NAME=$(cat $SECRETS_PREFIX/database_user_name)
    DATABASE_USER_PASSWORD=$(cat $SECRETS_PREFIX/database_user_password)

    echo "Creating user and database..."

    su-exec mysql mariadbd --bootstrap <<EOSQL
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS \`${DATABASE_NAME}\`;
CREATE USER IF NOT EXISTS '${DATABASE_USER_NAME}'@'%' IDENTIFIED BY '${DATABASE_USER_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${DATABASE_NAME}\`.* TO '${DATABASE_USER_NAME}'@'%';
FLUSH PRIVILEGES;
EOSQL
fi

echo "Setting MariaDB..."

exec /usr/bin/mariadbd --user=mysql --console --bind-address=0.0.0.0 --port=3306