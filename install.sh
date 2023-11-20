#!/bin/sh

apt install pwgen
./generate_secrets.sh
NOW=$( date '+%F_%H:%M:%S' )
mkdir ~/pretix-secrets-$NOW
cp ./secrets/* ~/pretix-secrets-$NOW/

# Traefik


# Pretix
mkdir /var/pretix-data
chown -R 15371:15371 /var/pretix-data

mkdir /etc/pretix
touch /etc/pretix/pretix.cfg
chown -R 15371:15371 /etc/pretix/
chmod 0700 /etc/pretix/pretix.cfg
cp pretix.cfg /etc/pretix.cfg

# Docker
docker stack deploy -c traefik/docker-compose.yml traefik
docker stack deploy -c docker-compose.yml ttn
