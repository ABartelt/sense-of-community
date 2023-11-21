#!/bin/sh

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


# Pretix
#chown -R 15371:15371 ./pretix/pretix-data
chown -R 15371:15371 ./pretix/etc/
chmod 0700 ./pretix/etc/pretix.cfg

docker network create --driver=overlay proxy

#docker-compose -c traefik/docker-compose.yml up -d
docker-compose -f pretix/docker-compose.yml up -d