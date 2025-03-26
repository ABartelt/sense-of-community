# Sense of Community Infrastructure

This repository contains the infrastructure configuration for various community applications, including deployment configurations for both Docker and Kubernetes environments.

## Repository Structure

```
.
├── microk8s-ansible/          # Ansible playbooks for MicroK8s installation
│   ├── hosts                 # Ansible inventory file
│   ├── microk8s-playbook.yml # Main playbook for MicroK8s setup
│   └── requirements.yml      # Ansible dependencies
│
├── helm/                     # Kubernetes Helm charts
│   ├── sense-of-community/  # Main Helm chart (parent)
│   │   ├── Chart.yaml      # Chart definition and dependencies
│   │   ├── values.yaml     # Default configuration values
│   │   └── README.md       # Chart documentation
│   ├── pretix/            # Pretix Helm chart (subchart)
│   ├── odoo/              # Odoo Helm chart (subchart)
│   └── shiftplanner/      # ShiftPlanner Helm chart (subchart)
│
└── docker-stack/            # Docker Compose configurations
    ├── traefik/           # Traefik reverse proxy configuration
    ├── pretix/            # Pretix application
    │   ├── docker-compose.yml
    │   ├── etc/          # Configuration files
    │   └── init.sql      # Database initialization
    ├── odoo/             # Odoo application
    │   ├── docker-compose.yml
    │   └── config/       # Configuration files
    └── shiftplanner/     # ShiftPlanner application
        ├── docker-compose.yml
        ├── config/       # Configuration files
        └── manifest.json # Application manifest
```

## Components

### 1. MicroK8s Ansible
Contains Ansible playbooks for automated installation and configuration of MicroK8s on target servers.

### 2. Helm Charts
The `helm` directory contains:
- Main chart `sense-of-community` that manages all applications and their shared infrastructure:
  - Shared PostgreSQL HA database (Bitnami)
  - Shared Redis Cluster (Bitnami)
  - Shared Keycloak authentication (Bitnami)
- Application subcharts:
  - Pretix chart
  - Odoo chart
  - ShiftPlanner chart

### 3. Docker Stack
Contains Docker Compose configurations for each application, useful for development or standalone deployments:
- Traefik reverse proxy
- Pretix with configuration
- Odoo with configuration
- ShiftPlanner with configuration

## Getting Started

### For Kubernetes Deployment
1. Install MicroK8s using the Ansible playbook:
```bash
cd microk8s-ansible
ansible-playbook -i hosts microk8s-playbook.yml
```

2. Deploy applications using Helm:
```bash
cd helm
helm dependency update sense-of-community
helm install sense-of-community ./sense-of-community -f my-values.yaml -n your-namespace
```

### For Docker Deployment
Use the Docker Compose configurations in the `docker-stack` directory:
```bash
cd docker-stack
cp .env.example .env  # Configure your environment variables
docker-compose -f traefik/docker-compose.yml up -d  # Start Traefik first
cd [application]
docker-compose up -d
```

## Documentation

- [MicroK8s Installation Guide](microk8s-ansible/README.md)
- [Helm Chart Documentation](helm/sense-of-community/README.md)
- Individual application documentation in their respective directories

<img src="sense-of-community-logo.png" alt="drawing" width="300"/>

Sense of community is a deployment of a tool set for private parties.
The goal is to provide a toolchain to manage guests as well as helpers seamlessly. 
The main application used for this purpose is [pretix](https://pretix.eu/about/en/).

[Pretix](https://pretix.eu/about/en/) and other services are provided via [traefik](https://doc.traefik.io/traefik/) as reverse-proxy. 
We recommend to use an external smtp server for sending emails. The configuration of a self-hosted e-mail service is not that easy.

## Requirements
This list is not complete. Please check the documentation of the tools for further information.
- [docker](https://docs.docker.com/engine/install/)t
- [docker-compose](https://docs.docker.com/compose/install/)
- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
- **Optional:** [openssl](https://www.openssl.org/) only for random password generation

## Get started
**1.** Clone this repository and create a docker network:
```bash
git clone git@github.com:ABartelt/sense-of-community.git /opt/sense-of-community
cd /opt/sense-of-community
sudo docker swarm init
sudo docker network create --driver=overlay proxy
```
**2. Optional** Create a copie of the `.env.example` file and prefill some generated passwords:
```bash
# Create .env file if it doesn't exist and fill it with some random passwords
if [ ! -f .env ]; then
    cp .env.example .env
    # Parse each entry of .env.example and generate a password for it
    value=$(openssl rand -base64 6)
    sed -i '' "s/POSTGRES_ADMIN_PASSWORD=/POSTGRES_ADMIN_PASSWORD=$value/g" .env
    value=$(openssl rand -base64 6)
    sed -i '' "s/PRETIX_POSTGRES_PASSWORD=/PRETIX_POSTGRES_PASSWORD=$value/g" .env
    value=$(openssl rand -base64 6)
    sed -i '' "s/PRETIX_POSTGRES_USER=/PRETIX_POSTGRES_USER=$value/g" .env
fi
```
**3.** Replacing the variables of your `.env` in all config files. See [Configuration](#configuration) for more information.
```bash
sudo ./replace.sh
```
**4.** Start the stack:
```bash
sudo chown -R 15371:15371 /opt/sense-of-community/pretix/etc/
sudo chmod 0700 /opt/sense-of-community/pretix/etc/pretix.cfg
docker stack deploy -c /opt/sense-of-community/traefik/docker-compose.yml traefik
docker stack deploy -c /opt/sense-of-community/pretix/docker-compose.yml pretix
```

## Services provided in this deployment
There are a couple of docker-compose files which contains the full softwarestack. They contain:
- [postgres](https://www.postgresql.org/) as database
- [postgres-backup](https://www.postgresql.org/docs/current/app-pgdump.html) as backup tool via `pg_dump
- [redis](https://redis.io/) as cache and message broker
- [traefik](https://doc.traefik.io/traefik/) as reverse-proxy
- [pretix](https://docs.pretix.eu/en/latest/admin/installation/docker_smallscale.html) as the main tool for guest management.

## Configuration
Variables and secrets that could be replaced in `.env`
Everything else should be configured in the `pretix.cfg` file. You find the full configuration options for pretix [here](https://docs.pretix.eu/en/latest/admin/config.html). 

| Section             | Key                          | Default Value              | Description                                                                                                             |
|---------------------|------------------------------|----------------------------|-------------------------------------------------------------------------------------------------------------------------|
| **Traefik**         | `TRAEFIK_DASHBOARD_HOSTNAME` | traefik.local              | The traefik dashboard is provided under this hostname.                                                                  |
|                     | `TRAEFIK_LETS_ENCRYPT_EMAIL` | your-email@tld.org         | This is needed by [letsencrypt](https://letsencrypt.org/) to issue TLS certificates. This is mandatory for cert issuing |
| **Pretix**          | `PRETIX_HOSTNAME`            | https://pretix.example.com |                                                                                                                         |
|                     | `PRETIX_INSTANCE_NAME`       | My Pretix instance         | Name your instance, e.g. "My organizer name"                                                                            |
| **Pretix database** | `POSTGRES_ADMIN_PASSWORD`    | Will be generated          |                                                                                                                         |
|                     | `PRETIX_POSTGRES_PASSWORD`   | Will be generated          |                                                                                                                         |
|                     | `PRETIX_POSTGRES_USER`       | Will be generated          |                                                                                                                         |
|                     | `PRETIX_POSTGRES_DB`         | pretix                     |                                                                                                                         |
| **Pretix Mail**     | `PRETIX_MAIL_HOST`           | **You have to set this**   | Here the smtp hostname is required. Like smtp.gmail.com                                                                 |
|                     | `PRETIX_MAIL_USER`           | **You have to set this**   | The smtp user which could login at the smtp hostname. Most commonly its an e-mail address.                              |
|                     | `PRETIX_MAIL_PASSWORD`       | **You have to set this**   | The credential for the username above if the server needs an authentication. Most do.                                   |
|                     | `PRETIX_MAIL_PORT`           | **You have to set this**   | Common ports for encrypted smtp connection are 587 or 465. In some cases 25. Look it up at your mail provider.          |
|                     | `PRETIX_MAIL_FROM`           | **You have to set this**   | E-Mail adresse which should be displayed if pretix sends mails.                                                         |
