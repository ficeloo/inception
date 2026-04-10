# User Documentation

> This documentation explains what you can do and see as an end user.

---

## Table of Contents

- [Understanding the Services](#understanding-the-services)
- [Starting and Stopping the Project](#starting-and-stopping-the-project)
- [Accessing the Website](#accessing-the-website)
- [Credentials](#credentials)
- [Health Check](#health-check)

---

## Understanding the Services

By deploying this project, you get your own website powered by **WordPress** and **NGINX** — plug and ready!

| Service       | Role                                              |
|---------------|---------------------------------------------------|
| **NGINX**     | Handles the server side (reverse proxy, HTTPS)    |
| **WordPress** | Handles the front-end of your website             |
| **MariaDB**   | The database — makes sure your data is persisted  |

---

## Starting and Stopping the Project

Nothing more simple!

**1. Clone the repository**

```bash
git clone git@vogsphere.42paris.fr:vogsphere/intra-uuid-2455d11c-9b8e-4c9b-a014-6314f1b74abf-7331075-tcros inception
```

**2. Build and start the project**

```bash
cd inception
make all
```

After a short while of dockerization, everything should be set up and ready to go!

**3. Stop the project**

```bash
make down
```

> After running `make down`, the website will no longer be accessible.

---

## Accessing the Website

Again, not rocket science here.

After starting the project, open your favorite browser and navigate to:

```
https://tcros.42.fr
```

> ⚠️ **Important:** `http://` will **NOT** work — only `https://` is supported.

### Administration Panel

To access the WordPress admin panel, go to:

```
https://tcros.42.fr/wp-admin
```

---

## Credentials

All credentials are managed through a `.env` file and a `secrets/` directory that **you must set up yourself**.

**Location of the `.env` file:**

```
srcs/.env
```

**Required secret files** (to be placed in your `secrets/` directory):

| Secret File                  | Purpose                        |
|------------------------------|--------------------------------|
| `mariadb_root_password.txt`  | Root password for MariaDB      |
| `mariadb_password.txt`       | User password for MariaDB      |

> 🔒 Never commit your `.env` file or `secrets/` directory to version control.

---

## Health Check

To verify that all services are running properly, run:

```bash
docker ps
```

You should see **3 running containers**:

| #  | Service       |
|----|---------------|
| 1  | `mariadb`     |
| 2  | `wordpress`   |
| 3  | `nginx`       |

**Expected output:**

```
CONTAINER ID   IMAGE            COMMAND                  CREATED          STATUS         PORTS                                     NAMES
baaca6b052d5   srcs-nginx       "nginx -g 'daemon of…"   10 seconds ago   Up 8 seconds   0.0.0.0:443->443/tcp, [::]:443->443/tcp   nginx
28771bedb8ab   srcs-wordpress   "/usr/local/bin/word…"   10 seconds ago   Up 9 seconds   9000/tcp                                  wordpress
59a58ef802a1   srcs-mariadb     "/usr/local/bin/mari…"   10 seconds ago   Up 9 seconds   3306/tcp                                  mariadb
```

If any container is missing or shows a status other than `Up`, something went wrong during the build step.
