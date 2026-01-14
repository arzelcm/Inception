#!/bin/sh

# Ensure permissions are correct after volume mount
chmod 755 /var/www/html
chown -R www-data:www-data /var/www/html
chmod 755 /run/php
chown -R www-data:www-data /run/php

install_and_configure_wordpress()
{
    if [ -f wp-config.php ]; then return 0; fi

    local DATABASE_NAME=$(cat $SECRETS_PREFIX/database_name)
    local DATABASE_USER_NAME=$(cat $SECRETS_PREFIX/database_user_name)
    local DATABASE_USER_PASSWORD=$(cat $SECRETS_PREFIX/database_user_password)
    local WEBSITE_ADMIN_USER=$(cat $SECRETS_PREFIX/website_admin_user)
    local WEBSITE_ADMIN_PASSWORD=$(cat $SECRETS_PREFIX/website_admin_password)
    local WEBSITE_ADMIN_EMAIL=$(cat $SECRETS_PREFIX/website_admin_email)
    local WEBSITE_AUTHOR_PASSWORD=$(cat $SECRETS_PREFIX/website_author_password)

    php -d memory_limit=512M /usr/local/bin/wp core download --path=/var/www/html --allow-root --force
    wp config create --dbname="$DATABASE_NAME" --dbuser="$DATABASE_USER_NAME" --dbpass="$DATABASE_USER_PASSWORD" --dbhost="$DATABASE_HOST"
    wp core install --url="$DOMAIN_NAME" --title="$WEBSITE_TITLE" --admin_user="$WEBSITE_ADMIN_USER" --admin_password="$WEBSITE_ADMIN_PASSWORD" --admin_email="$WEBSITE_ADMIN_EMAIL" --skip-email
    wp user create "$WEBSITE_AUTHOR_USER" "$WEBSITE_AUTHOR_EMAIL" --role=author --user_pass="$WEBSITE_AUTHOR_PASSWORD"
}

# Bonus: Install and configure redis-cache plugin
install_and_configure_redis_plugin()
{
    # Check if redis-cache plugin is installed
    wp plugin is-installed redis-cache
    
    # If the last command returns 0, means is installed, so return
    if [ $? -eq 0 ]; then return 0; fi;

    # Install plugin
    wp plugin install redis-cache --activate
    
    # Set redis configurations in wp-config.php
    wp config set WP_REDIS_HOST \"redis\"
    wp config set WP_REDIS_PORT \"6379\"
    wp config set WP_REDIS_PREFIX \"inception\"
    wp config set WP_REDIS_DATABASE \"0\"
    wp config set WP_REDIS_TIMEOUT \"1\"
    wp config set WP_REDIS_READ_TIMEOUT \"1\"

    # Enable object cache
    wp redis enable
}

install_and_configure_wordpress
# install_and_configure_redis_plugin
exec "$@"