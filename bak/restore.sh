echo
echo "RESTORE A BACKUP (files and/or database)"
echo "See github.com/vicenteherrera/bash"
echo

# We check and process parameter

if [ "$1" = "" ]; then
  echo "You must specify as the first parameter the full filename"
  echo "or base filename (without .files.tar.gz or .sql.tar.gz) to restore"
  exit
fi
bak_files=
bak_db=
if [ -f "$1" ]; then
  if [[ "$1" = *".sql.tar.gz" ]]; then
    bak_db="$1"
  else
    bak_files="$1"
  fi
else
  if [ -f "$1.files.tar.gz" ]; then
    bak_files="$1.files.tar.gz"
  fi
  if [ -f "$1.sql.tar.gz" ]; then
    bak_db="$1.sql.tar.gz"
  fi
fi
if [ "$bak_files" = "" ] && [ "$bak_db" = "" ]; then
  echo "Couldn't find specified file"
  echo "$1"
  echo "$1.files.tar.gz"
  echo "$1.sql.tar.gz"
  exit
fi


# Confirmation before going on
source ./bak_cfg.sh
REAL_DIR=$(readlink -f $DIRECTORY)
echo "Backup of files : $bak_files"
echo "Backup of DB    : $bak_db"
echo
echo "It's recommended to make a different backup of current state of site previously."
echo
echo "Target directory : $REAL_DIR"
echo "Target database  : $DB_NAME"
read -p "Are you sure you want to continue? Target DIR and DB will be DELETED (y/n) " confirmation
if [ "$confirmation" != "y" ] && [ "$confirmation" != "Y" ]; then
  exit
fi

# We restore the files
if [ "$bak_files" != "" ]; then
  echo "Deleting target directory..."
  chmod -R 777 $REAL_DIR
  rm -rf $REAL_DIR
  mkdir -p $DIRECTORY
  echo "Restoring files..."
  tar -xf $bak_files --directory $REAL_DIR/../
  echo
fi

if [ "$bak_db" != "" ]
then
  # TODO: Test if we can connect to database and exit otherwise
  echo "Dropping existing tables..."
  # Deleting tables code from http://www.cyberciti.biz/faq/how-do-i-empty-mysql-database/
  MYSQL=$(which mysql)
  AWK=$(which awk)
  GREP=$(which grep)
  TABLES=$($MYSQL --user=$DB_USER --host=$DB_HOST --password=$DB_PASS $DB_NAME -e 'show tables' | $AWK '{ print $1}' | $GREP -v '^Tables' )
  for t in $TABLES
  do
    # echo "Deleting $t table from $MDB database..."
    $MYSQL --user=$DB_USER --host=$DB_HOST --password=$DB_PASS $DB_NAME -e "drop table $t"
  done
  # TODO: Delete views and stored procedures

  echo "Restoring database..."
  mkdir -p ./temp
  tar -xvf $bak_db --directory ./temp
  # TODO: Check if extracted sql exists
  mysql --user=$DB_USER --host=$DB_HOST --password=$DB_PASS $DB_NAME < ./temp/$DB_NAME.sql
  rm -rf ./temp
  echo
fi


