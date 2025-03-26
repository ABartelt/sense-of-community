#!/bin/bash

# Function to read the password from the file if POSTGRES_PASSWORD_FILE is set
read_password() {
    if [ -n "$POSTGRES_PASSWORD_FILE" ] && [ -f "$POSTGRES_PASSWORD_FILE" ]; then
        POSTGRES_PASSWORD=$(cat "$POSTGRES_PASSWORD_FILE")
    fi
}

# Check if all required environment variables are set
if [ -z "$POSTGRES_HOST" ] || [ -z "$POSTGRES_USER" ] || [ -z "$POSTGRES_DBS" ]; then
    echo "One or more required environment variables are missing." >&2
    exit 1
fi

# Read the password from the file if POSTGRES_PASSWORD_FILE is set
read_password

# Check if POSTGRES_PASSWORD is set after trying to read from POSTGRES_PASSWORD_FILE
if [ -z "$POSTGRES_PASSWORD" ]; then
    echo "POSTGRES_PASSWORD is missing." >&2
    exit 1
fi

# Environment variables are passed in from docker-compose
HOST=$POSTGRES_HOST
USER=$POSTGRES_USER
PASSWORD=$POSTGRES_PASSWORD
DBS=$POSTGRES_DBS
BACKUP_DIR=/var/backup

# Ensure the backup directory exists
mkdir -p $BACKUP_DIR

# Loop over each database and perform the backup
for DB in $DBS; do
    # Generate a timestamped backup filename
    BACKUP_FILENAME=backup_${DB}_$(date +%Y%m%d_%H%M%S).sql

    # Perform the backup
    echo "Starting backup for database '$DB'..."
    if PGPASSWORD=$PASSWORD pg_dump -h $HOST -U $USER -d $DB > $BACKUP_DIR/$BACKUP_FILENAME; then
        echo "Backup successful: $BACKUP_DIR/$BACKUP_FILENAME"
    else
        echo "Backup failed for database '$DB'" >&2
        exit 1
    fi
done

# Delete old backups older than 65 days
echo "Deleting backups older than 65 days..."
find $BACKUP_DIR -type f -name '*.sql' -mtime +65 -exec rm {} \;

# Log completion
echo "Backup process completed."

# Sleep for an hour
sleep 3600