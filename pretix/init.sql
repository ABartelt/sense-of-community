CREATE USER pretix WITH PASSWORD 'arsch';
CREATE DATABASE pretix ENCODING UTF8;
GRANT ALL PRIVILEGES ON DATABASE pretix TO pretix;
ALTER DATABASE pretix OWNER TO pretix;

