#!/bin/sh

# Import envs from .env file
export $(cat .env | grep -v ^# | xargs)

# traefik config
sed -i '' "s/\${TRAEFIK_LETS_ENCRYPT_EMAIL}/${TRAEFIK_LETS_ENCRYPT_EMAIL}/g" traefik/traefik.yaml

# init.sql the init script for postgres
sed -i '' "s/\${PRETIX_POSTGRES_USER}/${PRETIX_POSTGRES_USER}/g" pretix/init.sql
sed -i '' "s/\${PRETIX_POSTGRES_DB}/${PRETIX_POSTGRES_DB}/g" pretix/init.sql
sed -i '' "s/\${PRETIX_POSTGRES_PASSWORD}/${PRETIX_POSTGRES_PASSWORD}/g" pretix/init.sql

# make pretix config accessible
sudo chown -R $(whoami):staff pretix/etc/pretix.cfg
sudo chmod g+rx pretix/etc/pretix.cfg

# pretix config
sed -i '' "s/\${PRETIX_POSTGRES_USER}/${PRETIX_POSTGRES_USER}/g" pretix/etc/pretix.cfg
sed -i ''  "s/\${PRETIX_POSTGRES_DB}/${PRETIX_POSTGRES_DB}/g" pretix/etc/pretix.cfgg
sed -i '' "s/\${PRETIX_POSTGRES_PASSWORD}/${PRETIX_POSTGRES_PASSWORD}/g" pretix/etc/pretix.cfg
sed -i '' "s/\${PRETIX_MAIL_HOST}/${PRETIX_MAIL_HOST}/g" pretix/etc/pretix.cfg
sed -i '' "s/\${PRETIX_MAIL_USER}/${PRETIX_MAIL_USER}/g" pretix/etc/pretix.cfg
sed -i '' "s/\${PRETIX_MAIL_PASSWORD}/${PRETIX_MAIL_PASSWORD}/g" pretix/etc/pretix.cfg

sed -i '' "s/\${PRETIX_HOSTNAME}/${PRETIX_HOSTNAME} /g" pretix/etc/pretix.cfg
sed -i '' "s/\${PRETIX_INSTANCE_NAME}/${PRETIX_INSTANCE_NAME}/g" pretix/etc/pretix.cfg
sed -i '' "s/\${PRETIX_MAIL_PORT}/${PRETIX_MAIL_PORT}/g" pretix/etc/pretix.cfg