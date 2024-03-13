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

# Prompt user to select a backup file from AWS S3
echo "Select a backup file from the following list:"
aws s3 ls s3://$S3_BUCKET/$S3_PREFIX/
echo "Enter the filename to restore (including the path):"
read SELECTED_FILE

# Download the selected backup file from AWS S3
aws s3 cp s3://$S3_BUCKET/$S3_PREFIX/$SELECTED_FILE $TEMP_DIR

# Extract the backup file
tar -zxvf $TEMP_DIR/$SELECTED_FILE -C $TEMP_DIR

# Restore MongoDB database
mongorestore --host=$MONGO_HOST --port=$MONGO_PORT --username=$MONGO_USERNAME --password=$MONGO_PASSWORD --authenticationDatabase=$MONGO_AUTHDB --nsInclude="$DATABASE_NAME.*" $TEMP_DIR --drop

# Remove temporary files
rm -rf $TEMP_DIR/$DATABASE_NAME
