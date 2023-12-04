#!/bin/sh

sudo docker-compose -f pretix/docker-compose.yml down

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    cp .env.example .env

    # Parse each entry of .env.example and generate a password for it
    while read line; do
        if [[ $line == *"="* ]]; then
            key=$(echo $line | cut -d '=' -f 1)
            value=$(openssl rand -base64 6)
            sed -i '' "s/$key=/$key=$value/g" .env
        fi
    done < .env
fi


# Import envs from .env file
export $(cat .env | grep -v ^# | xargs)

sudo chown -R $(whoami):staff pretix/etc/pretix.cfg
sudo chmod g+rx pretix/etc/pretix.cfg

sed -i '' "s/\${PRETIX_POSTGRES_USER}/${PRETIX_POSTGRES_USER}/g" pretix/init.sql
sed -i '' "s/\${PRETIX_POSTGRES_DB}/${PRETIX_POSTGRES_DB}/g" pretix/init.sql
sed -i '' "s/\${PRETIX_POSTGRES_PASSWORD}/${PRETIX_POSTGRES_PASSWORD}/g" pretix/init.sql

sed -i '' "s/\${PRETIX_POSTGRES_USER}/${PRETIX_POSTGRES_USER}/g" pretix/etc/pretix.cfg
sed -i ''  "s/\${PRETIX_POSTGRES_DB}/${PRETIX_POSTGRES_DB}/g" pretix/etc/pretix.cfgg
sed -i '' "s/\${PRETIX_POSTGRES_PASSWORD}/${PRETIX_POSTGRES_PASSWORD}/g" pretix/etc/pretix.cfg
sed -i '' "s/\${PRETIX_MAIL_HOST}/${PRETIX_MAIL_HOST}/g" pretix/etc/pretix.cfg
sed -i '' "s/\${PRETIX_MAIL_USER}/${PRETIX_MAIL_USER}/g" pretix/etc/pretix.cfg
sed -i '' "s/\${PRETIX_MAIL_PASSWORD}/${PRETIX_MAIL_PASSWORD}/g" pretix/etc/pretix.cfg

sed -i '' "s/\${PRETIX_HOSTNAME}/${PRETIX_HOSTNAME} /g" pretix/etc/pretix.cfg
sed -i '' "s/\${PRETIX_INSTANCE_NAME}/${PRETIX_INSTANCE_NAME}/g" pretix/etc/pretix.cfg
sed -i '' "s/\${PRETIX_MAIL_PORT}/${PRETIX_MAIL_PORT}/g" pretix/etc/pretix.cfg


# Pretix
#chown -R 15371:15371 ./pretix/pretix-data
sudo chown -R 15371:15371 ./pretix/etc/
sudo chmod 0700 ./pretix/etc/pretix.cfg

docker network create proxy

docker-compose -c traefik/docker-compose.yml up -d
docker-compose -f pretix/docker-compose.yml up -d