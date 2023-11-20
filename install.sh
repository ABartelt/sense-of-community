#!/bin/sh

# Pretix
chown -R 15371:15371 ./pretix/pretix-data

chown -R 15371:15371 ./pretix/etc/
chmod 0700 ./pretix/etc/pretix.cfg

docker stack deploy -c traefik/docker-compose.yml traefik
docker stack deploy -c pretix/docker-compose.yml pretix