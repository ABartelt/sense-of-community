#!/bin/bash

# Check if all required environment variables are set
if [ -z "$POSTGRES_HOST" ] || [ -z "$POSTGRES_USER" ] || [ -z "$POSTGRES_PASSWORD" ] || [ -z "$POSTGRES_DB" ]; then
    echo "One or more required environment variables are missing." >&2
    exit 1
fi

# Environment variables are passed in from docker-compose
HOST=$POSTGRES_HOST
USER=$POSTGRES_USER
PASSWORD=$POSTGRES_PASSWORD
DB=$POSTGRES_DB
BACKUP_DIR=/var/backup

# Generate a timestamped backup filename
BACKUP_FILENAME=backup_$(date +%Y%m%d_%H%M%S).sql

# Perform the backup
echo "Starting backup for database '$DB'..."
if PGPASSWORD=$PASSWORD pg_dump -h $HOST -U $USER -d $DB > $BACKUP_DIR/$BACKUP_FILENAME; then
    echo "Backup successful: $BACKUP_DIR/$BACKUP_FILENAME"
else
    echo "Backup failed for database '$DB'" >&2
    exit 1
fi

# Delete old backups older than 65 days
echo "Deleting backups older than 65 days..."
find $BACKUP_DIR -type f -name '*.sql' -mtime +65 -exec rm {} \;

# Log completion
echo "Backup process completed."

# Sleep for an hour
sleep 3600