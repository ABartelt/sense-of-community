# sense-of-community
Is a hosting of pretix as a private party guest management tool. The goal is to provide a simple and easy  guest management
Pretix is provided via traefik as reverse-proxy. We do you an external smtp server for sending emails.
The configruation takes place in `pretix.cfg` under `[mail]`.
## Docker-Compose
The Docker-Compose file contains the full softwarestack needed to run Pretix. It should contain
- Postgres
- redis
- nginx
- pretix

## Installation
Befor the installation you need to adjust the `pretix.cfg` to your needs.

The stack should be installed with the `install.sh` script.</br>
The Script generates all needed Passwords as Docker secret files in the subdirectory `./secrets`, prepares directories to mount to pretix Container and starts the docker stack afterwards.</br>
To prevent the Passwords from loss they are copied to a folder `~/pretix-secrets-$( date '+%F_%H:%M:%S' )/`

## Variables and Secrets to be replaced
- POSTGRES_PASSWORD
- POSTGRES_USER
- POSTGRES_DB
- PRETIX_INSTANCE_NAME
- PRETIX_HOSTNAME