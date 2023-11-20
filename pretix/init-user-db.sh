#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "pretix" --dbname "pretix" <<-EOSQL
	CREATE USER pretix WITH PASSWORD 'arsch';
	CREATE DATABASE pretix
        ENCODING UTF8;
	GRANT ALL PRIVILEGES ON DATABASE pretix TO pretix;
	GRANT ALL ON SCHEMA public TO pretix;
EOSQL