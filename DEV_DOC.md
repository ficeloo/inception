# Developer Documentation

> This documentation describes what you can do and configure as a developer.

---

## Table of Contents

- [Setting Up the Environment](#setting-up-the-environment)
  - [NGINX](#nginx)
  - [MariaDB](#mariadb)
  - [WordPress](#wordpress)
  - [Environment Variables](#environment-variables)
  - [Secrets](#secrets)
- [Build and Launch the Project](#build-and-launch-the-project)
- [Relevant Commands](#relevant-commands)
- [Where Is My Data?](#where-is-my-data)

---

## Setting Up the Environment

Setting up the environment involves configuration files from each service. Let's go through them one by one.

### NGINX

Configuration file location:

```
srcs/requirements/nginx/conf/nginx.conf
```

Here you can configure:
- The directory where your website pages will be served from
- Your server name (`server_name`)
- Your SSL certificate paths (`ssl_certificate`, `ssl_certificate_key`)

> ⚠️ **Be careful with SSL** — a bad certificate configuration will lead to an unsecured website or a broken HTTPS setup.

For a full reference of NGINX directives and contexts, check the official documentation:
[https://nginx.org/en/docs/ngx_core_module.html](https://nginx.org/en/docs/ngx_core_module.html)

---

### MariaDB

Configuration file location:

```
srcs/requirements/mariadb/conf/my.cnf
```

You can modify this file to change things like the database username or the data directory. However, modifying these values requires a solid understanding of how MariaDB works.

> 💡 Before touching `my.cnf`, it's a good idea to read the setup script first:
> `srcs/requirements/mariadb/tools/`

---

### WordPress

Configuration file location:

```
srcs/requirements/wordpress/conf/www.conf
```

This is the PHP-FPM pool configuration file. You can use it to adjust how WordPress communicates with other services like NGINX (e.g., the socket or TCP port it listens on, the process manager settings).

---

### Environment Variables

Once your service configs are set, you can define your environment variables in:

```
srcs/.env
```

> ⚠️ Make sure the variable names in `.env` **exactly match** the ones referenced in your configuration files!

Here are the expected environment variables and what they represent:

#### Server Setup

| Variable      | Description                          |
|---------------|--------------------------------------|
| `DOMAIN_NAME` | Your domain name                     |
| `PORT`        | Main listening port                  |
| `PHP_PORT`    | PHP port used by WordPress           |
| `DB_PORT`     | Database listening port              |
| `HTTP`        | NGINX listening port                 |

#### MySQL / MariaDB Setup

| Variable     | Description        |
|--------------|--------------------|
| `MYSQL_NAME` | Database name      |
| `MYSQL_USER` | Database username  |

#### WordPress Setup

| Variable        | Description              |
|-----------------|--------------------------|
| `WP_TITLE`      | Title of your website    |
| `WP_ADMIN_USR`  | Admin username           |
| `WP_ADMIN_EMAIL`| Admin email address      |
| `WP_USER`       | First user username      |
| `WP_EMAIL`      | First user email address |

---

### Secrets

The following variables are **passwords** and must **never** be stored in the `.env` file:

| Secret Variable    | Description                        |
|--------------------|------------------------------------|
| `WP_PASS`          | WordPress first user password      |
| `WP_ADMIN_PASS`    | WordPress admin password           |
| `MYSQL_PASS`       | MariaDB user password              |
| `MYSQL_ROOT_PASS`  | MariaDB root password              |

Each one must be a plain `.txt` file containing **only the password**, placed in a `secrets/` directory at the root of the project:

```
secrets/
├── wp_password.txt
├── wp_admin_password.txt
├── mysql_password.txt
└── mysql_root_password.txt
```

> 🔒 **Never commit your `secrets/` directory or `.env` file to version control.**

---

## Build and Launch the Project

The entry point for the project is the Docker Compose file located at:

```
srcs/docker-compose.yml
```

This is where you configure services, networks (bridges), secrets, and volumes — basically how all the containers know about each other and work together. Refer to the official documentation for guidance:
[https://docs.docker.com/compose/gettingstarted](https://docs.docker.com/compose/gettingstarted)

Once everything is configured, the `Makefile` at the root of the project wraps the Docker Compose commands. Here's what each target does:

| Command        | Effect                                                      |
|----------------|-------------------------------------------------------------|
| `make all`     | Builds images and starts all containers                     |
| `make down`    | Stops and removes all running containers                    |
| `make clean`   | Removes containers only (data volumes are preserved)        |
| `make fclean`  | Removes containers **and** all persistent data              |
| `make help`    | Displays all available make targets with descriptions       |

> ⚠️ `make fclean` is destructive — it will erase all stored data. Use with caution.

---

## Relevant Commands

Useful Docker commands for day-to-day container management:

**List running containers:**
```bash
docker ps
```

**List all containers (including stopped ones):**
```bash
docker ps -a
```

**View logs of a specific container:**
```bash
docker logs <container_name>
# Example:
docker logs nginx
docker logs wordpress
docker logs mariadb
```

**Follow logs in real time:**
```bash
docker logs -f <container_name>
```

**Open a shell inside a running container:**
```bash
docker exec -it <container_name> sh
# Example:
docker exec -it wordpress sh
```

**List all volumes:**
```bash
docker volume ls
```

**Inspect a volume (see where data is stored on the host):**
```bash
docker volume inspect <volume_name>
```

**Remove a specific volume manually:**
```bash
docker volume rm <volume_name>
```

> ⚠️ Removing a volume is irreversible. Make sure you know what you're deleting.

**Remove all unused volumes:**
```bash
docker volume prune
```

---

## Where Is My Data?

The persistent data for all services is stored locally on the host machine at:

```
/home/tcros/data/
```

This path is mounted as a Docker volume, which means **stopping or removing containers will not affect your data**. It persists across restarts.

If you want to wipe the data entirely, you can do so either manually:

```bash
rm -rf /home/tcros/data/
```

Or through the Makefile shortcut:

```bash
make fclean
```

> 💡 The volume mount paths are defined in `srcs/docker-compose.yml` — you can change the host path there if needed.
