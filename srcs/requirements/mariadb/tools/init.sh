#!/bin/sh
set -e

# Inicialitza MariaDB si encara no hi ha base de dades
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Inicialitzant MariaDB..."
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql
fi

# Només crea usuari i base de dades si existeix la carpeta de secrets
if [ -n "$SECRETS_PREFIX" ] && [ -f "$SECRETS_PREFIX/database_name" ]; then
    DATABASE_NAME=$(cat $SECRETS_PREFIX/database_name)
    DATABASE_USER_NAME=$(cat $SECRETS_PREFIX/database_user_name)
    DATABASE_USER_PASSWORD=$(cat $SECRETS_PREFIX/database_user_password)

    echo "Creant usuari i base de dades..."

    # Utilitzem mariadbd en mode bootstrap per crear usuari i DB
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

echo "Arrencant MariaDB..."
# Arrenca MariaDB normal, escoltant TCP
exec /usr/bin/mariadbd --user=mysql --console --bind-address=0.0.0.0 --port=3306