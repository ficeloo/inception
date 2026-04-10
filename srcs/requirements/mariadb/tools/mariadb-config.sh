#!/bin/bash

chown -R mysql:mysql /var/lib/mysql;

MYSQL_PASS=$(cat /run/secrets/mariadb_password);
MYSQL_ROOT_PASS=$(cat /run/secrets/mariadb_root_password);

# install mariadb database
mariadb-install-db --user=mysql --datadir=/var/lib/mysql;

# launch database
mysqld --bootstrap << EOF
USE mysql;
FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS ${MYSQL_NAME};

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASS}';
GRANT ALL ON ${MYSQL_NAME}.* TO '${MYSQL_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASS}';

FLUSH PRIVILEGES;
EOF

exec mysqld_safe;
