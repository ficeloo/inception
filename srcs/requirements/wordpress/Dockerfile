# syntax=docker/dockerfile:1
FROM debian:bookworm

# install app dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y wget php8.2 php-fpm php-mysql mariadb-client

# get wordpress
RUN wget https://fr.wordpress.org/wordpress-6.0-fr_FR.tar.gz

# create destination files
RUN mkdir -p /var/www
RUN mkdir -p /run/php
RUN mkdir -p /usr/local/bin/wordpress

# decompress wordpress file
RUN tar -xzvf wordpress-6.0-fr_FR.tar.gz && mv wordpress /var/www && rm -rf wordpress-6.0-fr_FR.tar.gz

# change permission for wp directory
RUN chown -R root:root /var/www/wordpress

# copy files from container to the machine
COPY /tools/wp-config.sh /usr/local/bin/wordpress/wp-config.sh
COPY /conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# install a CLI wordpress for easier configuration
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

# authorize execution
RUN chmod +x /usr/local/bin/wordpress/wp-config.sh

# launch configuration
ENTRYPOINT ["/usr/local/bin/wordpress/wp-config.sh"]
