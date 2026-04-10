#!/bin/bash

# attendre que mariadb soit pret
sleep 5

# change permission
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

MYSQL_PASS=$(cat /run/secrets/mariadb_password);
WP_ADMIN_PASS=$(cat /run/secrets/wp_admin_password);
WP_PASS=$(cat /run/secrets/wp_password);

if [ ! -f "/var/www/wordpress/wp-config.php" ]; then
	wp config create --allow-root \
		--dbname="${MYSQL_NAME}" \
		--dbuser="${MYSQL_USER}" \
		--dbpass="${MYSQL_PASS}" \
		--dbhost=mariadb:"${DB_PORT}" \
		--path='/var/www/wordpress'

	wp core install --allow-root \
		--url=${DOMAIN_NAME} \
		--title=${WP_TITLE} \
		--admin_user=${WP_ADMIN_USR} \
		--admin_password=${WP_ADMIN_PASS} \
		--admin_email=${WP_ADMIN_EMAIL} \
		--path='/var/www/wordpress' \
		--skip-email

	wp user create  --allow-root ${WP_USER} ${WP_EMAIL} \
		--role=author \
		--user_pass=${WP_PASS} \
		--path='/var/www/wordpress'

fi

exec /usr/sbin/php-fpm8.2 -F;
