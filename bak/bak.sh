#!/bin/bash 
# Importing configuration
source ./bak_cfg.sh
# TODO: Validate input configuration

TIMEMARK=$(TZ=$TIMEZONE date '+%Y-%m-%dT%H,%M,%S')

echo Executing backup of $DIRECTORY directory $TIMEMARK
tar -zcvf "$BAK_NAME-$TIMEMARK$1.files.tar.gz" $DIRECTORY

echo Executing backup of $DB_NAME database
mysqldump --opt -u$DB_USER -p$DB_PASS -h$DB_HOST $DB_NAME >$DB_NAME.sql
echo Compressing result
tar -zcvf "$BAK_NAME-$TIMEMARK$1.sql.tar.gz" $DB_NAME.sql
rm $DB_NAME.sql
ls -l $DB_NAME*.tar.gz
