*This project has been created as part of the 42 curriculum by tcros.*

---

# Inception

## Table of Contents

- [Description](#description)
- [Project Description](#under-the-hood)
  - [Virtual Machines vs Docker](#virtual-machines-vs-docker)
  - [Secrets vs Environment Variables](#secrets-vs-environment-variables)
  - [Docker Network vs Host Network](#docker-network-vs-host-network)
  - [Docker Volumes vs Bind Mounts](#docker-volumes-vs-bind-mounts)
- [Instructions](#instructions)
- [Resources](#resources)

---

## Description

**Inception** is a system administration project from the 42 curriculum. The goal is simple on paper: build a small but fully functional web infrastructure using **Docker** and **Docker Compose**, from scratch, inside a virtual machine.

Under the hood, three services work together to make it happen:

| Service       | Role                                          |
|---------------|-----------------------------------------------|
| **NGINX**     | Reverse proxy — the front door, HTTPS only    |
| **WordPress** | The CMS powering the website                  |
| **MariaDB**   | The database keeping everything persistent    |

This project is really about learning how to think in containers — how to isolate services, make them talk to each other, and keep sensitive data safe.

---

## Project Description

Docker is a platform for building, deploying, and running **containers** — lightweight, isolated environments that bundle an app with everything it needs to run.

The big win: every developer runs the exact same environment, regardless of their machine.

---

### Virtual Machines vs Docker

At first glance, containers and VMs look similar — they both isolate an environment. But they do it very differently.

| | Virtual Machine | Docker Container |
|---|---|---|
| **Isolation** | Full OS simulation via a hypervisor | Process-level isolation, shares the host kernel |
| **Boot time** | Minutes | Seconds |
| **Resource usage** | Heavy — dedicated RAM and CPU | Lightweight — shares host resources |
| **Portability** | Low — large disk images | High — small, layered images |
| **Best for** | Full OS isolation, legacy software | Microservices, reproducible dev environments |

A VM emulates an entire machine — CPU, memory, storage — and runs a full guest OS on top of it. Docker skips all of that: it shares the host kernel and only isolates the process. You get the isolation you need, without the overhead you don't.

---

### Secrets vs Environment Variables

Both can carry configuration values into your containers, but they're not interchangeable.

| | Environment Variables | Secrets |
|---|---|---|
| **Purpose** | General config — ports, usernames, domain names… | Sensitive data — passwords, tokens, keys… |
| **Storage** | `.env` file, plain text | Separate files, injected at runtime |
| **Risk if leaked** | Low — mostly non-sensitive | High — direct security compromise |
| **Visibility** | Accessible to any process in the container | Mounted as files, scoped to the service that needs them |

In this project, environment variables handle the non-sensitive stuff: `DOMAIN_NAME`, `MYSQL_USER`, `WP_TITLE`… Things you might want to tweak without worrying about exposing anything critical.

Passwords — `MYSQL_ROOT_PASS`, `WP_ADMIN_PASS` and friends — live as Docker secrets: plain `.txt` files injected into containers at runtime, never baked into images, never committed to Git.

---

### Docker Network vs Host Network

When containers need to talk to each other (or to the outside world), you have two main options.

| | Docker Bridge Network | Host Network |
|---|---|---|
| **Isolation** | Private internal network between containers | Containers share the host's network stack directly |
| **Security** | High — nothing exposed unless explicitly mapped | Low — all ports open on the host by default |
| **Port conflicts** | Avoided — each container gets its own IP | Possible — containers and host compete for the same ports |
| **Best for** | Multi-service apps like this one | Performance-critical setups, low-level debugging |

This project uses a custom **bridge network**. NGINX, WordPress, and MariaDB can find each other by name (e.g., `wordpress:9000`) without any of them being exposed to the outside world — except NGINX, which is the only one listening on port `443`.

---

### Docker Volumes vs Bind Mounts

Containers are ephemeral by design — kill one, and its filesystem disappears with it. Volumes and bind mounts are the two ways to make data outlive a container.

| | Docker Volumes | Bind Mounts |
|---|---|---|
| **Managed by** | Docker | The host filesystem |
| **Location** | Docker's internal storage (`/var/lib/docker/volumes/`) | Any path you pick on the host |
| **Portability** | High — works across environments | Low — tied to a specific host path |
| **Best for** | Production data, clean abstraction | Dev setups, inspecting data directly from the host |

---

## Instructions

**1. Clone the repository**

```bash
git clone git@vogsphere.42paris.fr:vogsphere/intra-uuid-2455d11c-9b8e-4c9b-a014-6314f1b74abf-7331075-tcros inception
cd inception
```

**2. Register the domain on your machine**

```bash
echo "127.0.0.1 tcros.42.fr" | sudo tee -a /etc/hosts
```

> This tells your machine to resolve `tcros.42.fr` locally instead of hitting a real DNS server.

**3. Build and start everything**

```bash
make all
```

**4. Open your browser and head to:**

```
https://tcros.42.fr
```

> ⚠️ `http://` will **NOT** work — NGINX only accepts HTTPS connections.

**To stop the project:**

```bash
make down
```

For the full list of available commands, check the [Developer Documentation](DEV_DOC.md).
For credentials and service access, check the [User Documentation](USER_DOC.md).

---

## Resources

### Official Documentation

- [Docker Official Docs](https://docs.docker.com)
- [MariaDB Docs](https://mariadb.com/docs/)
- [NGINX SSL Module](https://nginx.org/en/docs/http/ngx_http_ssl_module.html#ssl_certificate)
- [WordPress Server Requirements](https://wordpress.org/about/requirements/)

### Articles & Tutorials

- [Docker — Wikipedia (FR)](https://fr.wikipedia.org/wiki/Docker_(logiciel))
- [NGINX — Wikipedia (FR)](https://fr.wikipedia.org/wiki/NGINX)
- [Demystifying ENTRYPOINT and CMD in Docker — AWS Blog (FR)](https://aws.amazon.com/fr/blogs/france/demystifier-entrypoint-et-cmd-dans-docker/)
- [Building Docker Images — CHTC](https://chtc.cs.wisc.edu/uw-research-computing/docker-build)
- [Deploying Containers with Docker — Axopen (FR)](https://www.axopen.com/blog/2021/03/docker-tuto-deployer-conteneurs/)
- [Configure NGINX for TLS 1.2 and 1.3 — CyberCiti](https://www.cyberciti.biz/faq/configure-nginx-to-use-only-tls-1-2-and-1-3/)
- [Understanding the Events Context in NGINX — Medium](https://medium.com/@caring_smitten_gerbil_914/understanding-the-events-context-in-nginx-how-it-shapes-server-performance-%EF%B8%8F-c33bf0ae4c61)
- [MariaDB with Docker — IONOS (FR)](https://www.ionos.fr/digitalguide/hebergement/aspects-techniques/mariadb-docker/)
- [MariaDB via Docker — MariaDB Docs](https://mariadb.com/docs/server/server-management/automated-mariadb-deployment-and-administration/docker-and-mariadb/installing-and-using-mariadb-via-docker)
- [Install MySQL / MariaDB — CodeWithSusan](https://codewithsusan.com/notes/install-mysql-mariadb)
- [Inception Tutorial — GradeMe (FR)](https://tuto.grademe.fr/inception/)

### Video

- [NetworkChuck — Docker Tutorial](https://www.youtube.com/@NetworkChuck) — YouTube

### README Reference

- [How to Write a Good README — FreeCodeCamp](https://www.freecodecamp.org/news/how-to-write-a-good-readme-file/)

---

### AI Usage

AI (Claude by Anthropic) was used in this project for the following tasks:

- **Documentation** — Drafting and formatting `README.md`, `USER_DOC.md`, and `DEV_DOC.md` from rough notes, while preserving the author's writing style
- **Comparison sections** — Structuring and writing the four technical comparisons in the *Project Description* section
- **Proofreading** — Fixing typos, improving clarity, and ensuring idiomatic Markdown throughout

AI was **not** used to write any code, configuration files, or scripts for the project itself.
