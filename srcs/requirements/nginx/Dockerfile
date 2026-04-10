# syntax=docker/dockerfile:1
FROM debian:bookworm

# indicate which port will be used
EXPOSE 443

# install app dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl

# generate certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx-selfsigned.key -out /etc/nginx/ssl/nginx-selfsigned.crt -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42Paris/CN=tcros.42.fr/UID=tcros"


# Copy files from container to the machine
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Launch nginx
ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]
