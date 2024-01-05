# sense-of-community
Is a hosting of pretix as a private party guest management tool. The goal is to provide a simple and easy  guest management
Pretix is provided via traefik as reverse-proxy. 
We do you an external smtp server for sending emails. The configruation takes place in `pretix.cfg` under `[mail]`.
## Docker-Compose
The Docker-Compose file contains the full softwarestack needed to run Pretix. It should contain
- postgres
- postgres-backup
- redis
- nginx
- pretix

## Installation
Before the installation you need to adjust the `pretix.cfg` to your needs.

The stack should be installed with the `install.sh` script.</br>
The Script generates all needed Passwords as Docker secret files in the subdirectory `./secrets`, prepares directories to mount to pretix Container and starts the docker stack afterwards.</br>
To prevent the Passwords from loss they are copied to a folder `~/pretix-secrets-$( date '+%F_%H:%M:%S' )/`

## Variables and secrets to be replaced in .env
- PRETIX_HOSTNAME= Should be something like https://pretix.example.com
- PRETIX_INSTANCE_NAME= Name your instance, e.g. "My Pretix"
### Database
- POSTGRES_ADMIN_PASSWORD=
- PRETIX_POSTGRES_PASSWORD=
- PRETIX_POSTGRES_USER=
- PRETIX_POSTGRES_DB=

### Mail settings
- PRETIX_MAIL_HOST=
- PRETIX_MAIL_USER=
- PRETIX_MAIL_PASSWORD=
- PRETIX_MAIL_PORT=
- PRETIX_MAIL_FROM=

# Run
```bash
sudo docker network create --driver=overlay proxy
docker stack deploy -c /opt/traefik/docker-compose.yml traefik
chown -R 15371:15371 ./pretix/etc/
chmod 0700 ./pretix/etc/pretix.cfg
docker stack deploy -c /opt/pretix/docker-compose.yml pretix
```