#!/bin/bash
set -e

# Lies die Secrets
POSTGRES_USER=postgres
KEYCLOAK_POSTGRES_PASSWORD=$(cat /run/secrets/keycloak_postgres_password)

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
    create user keycloak with password '${KEYCLOAK_POSTGRES_PASSWORD}';
    create database keycloak with owner keycloak;
EOSQL
