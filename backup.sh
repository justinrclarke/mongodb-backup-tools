#!/bin/bash

# MongoDB Connection Information
MONGO_HOST="127.0.0.1"
MONGO_PORT="27017"
MONGO_USERNAME=""
MONGO_PASSWORD=""
MONGO_AUTHDB=""
DATABASE_NAME=""

# AWS S3 Configuration
S3_BUCKET=""
S3_PREFIX=""

# Temporary directory to store backup file
TEMP_DIR="/tmp"

# Timestamp for backup file
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
BACKUP_FILE="${DATABASE_NAME}_${TIMESTAMP}.tar.gz"

# Backup MongoDB database
mongodump --host $MONGO_HOST --port $MONGO_PORT --username $MONGO_USERNAME --password $MONGO_PASSWORD --authenticationDatabase $MONGO_AUTHDB --db $DATABASE_NAME --out $TEMP_DIR

# Compress the backup
tar -zcvf $TEMP_DIR/$BACKUP_FILE $TEMP_DIR/$DATABASE_NAME

# Copy the backup file to AWS S3
aws s3 cp $TEMP_DIR/$BACKUP_FILE s3://$S3_BUCKET/$S3_PREFIX/

# Remove temporary backup files
rm $TEMP_DIR/$BACKUP_FILE
rm -rf $TEMP_DIR/$DATABASE_NAME
