# syntax=docker/dockerfile:1
FROM debian:bookworm

# install app dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y mariadb-server

# create destination files
RUN mkdir -p /usr/local/bin/mariadb
RUN mkdir -p /var/lib/mysql
RUN mkdir -p /run/mysqld

# copy files from container to the machine
COPY /tools/mariadb-config.sh /usr/local/bin/mariadb/mariadb-config.sh
COPY /conf/my.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# change permission to configure mariadb
RUN chown -R mysql:mysql /var/lib/mysql
RUN chown -R mysql:mysql /run/mysqld
RUN chmod 777 /run/mysqld
RUN chmod +x /usr/local/bin/mariadb/mariadb-config.sh

# launch configuration
ENTRYPOINT ["/usr/local/bin/mariadb/mariadb-config.sh"]
