#!/bin/bash 
source ./bak_cfg.sh

TIMEMARK=$(TZ=Europe/Madrid date '+%y-%m-%d_%H;%M')

echo Executing backup of $DIRECTORY directory $TIMEMARK
tar -zcvf "$BAK_NAME-$TIMEMARK.files.tar.gz" $DIRECTORY

echo Executing backup of $DB_NAME database
mysqldump --opt -u$DB_USER -p$DB_PASS -h$DB_HOST $DB_NAME >$DB_NAME.sql
echo Compressing result
tar -zcvf "$BAK_NAME-$TIMEMARK.sql.tar.gz" $DB_NAME.sql
rm $DB_NAME.sql
ls -l $DB_NAME*.tar.gz
