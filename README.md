# !WIP!
# sense-of-community
Private party guest mangement tool

## Docker-Compose
The Docker-Compose File contains the full softwarestack needed to run Pretix. It should contain
- Postgres
- postfix + mysql-light
- redis
- nginx
- pretix

## Installation
Befor the installation you need to adjust the pretix.cfg and nginx-default.conf to your needs.

The stack should be installed with the `install.sh` script.</br>
The Script generates all needed Passwords as Docker secret files in the subdirectory `./secrets`, prepares directories to mount to pretix Container and starts the docker stack afterwards.</br>
To prevent the Passwords from loss they are copied to a folder `~/pretix-secrets-$( date '+%F_%H:%M:%S' )/`
