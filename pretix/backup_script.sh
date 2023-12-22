#!/bin/bash

# Database backup script

# Environment variables are passed in from docker-compose
HOST=$POSTGRES_HOST
USER=$POSTGRES_USER
PASSWORD=$POSTGRES_PASSWORD
DB=$POSTGRES_DB
BACKUP_DIR=/var/backup

# Backup
pg_dump -h $HOST -U $USER -d $DB > $BACKUP_DIR/backup_$(date +%Y%m%d_%H%M%S).sql

# Delete old backups older than 65 days
find $BACKUP_DIR -type f -name '*.sql' -mtime +65 -exec rm {} \;

# Sleep for an hour
sleep 3600