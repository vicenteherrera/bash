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
echo "$bak_files"
echo "$bak_db"
echo "Target directory: $REAL_DIR"
echo "Target database: $DB_NAME"
echo
echo "Before continuing, you MUST remove any original files and/or database content"
echo "It's recommended to make a different backup of current state of site previously."
echo
echo "Are you sure you want to continue? (y/n)"
read confirmation
if [ "$confirmation" != "y" ] && [ "$confirmation" != "Y" ]; then
  exit
fi

# We restore the files
if [ "$bak_files" != "" ]; then
  mkdir -p $DIRECTORY
  echo "Restoring files..."
  tar -xvf $bak_files --directory $REAL_DIR/../
  echo
fi

if [ "$bak_db" != "" ]
then
  echo "Restoring database"
  mkdir -p ./temp
  tar -xvf $bak_db --directory ./temp
  mysql --user=$DB_USER --host=$DB_HOST --password=$DB_PASS $DB_NAME < ./temp/$DB_NAME.sql
  rm -rf ./temp
  echo
fi


