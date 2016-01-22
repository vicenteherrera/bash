bash
====

A collection of bash scripts.

All code created by Vicente Herrera (www.vicenteherrera.com), unless stated
otherwise.

GNU Lesser General Public License v3: http://www.gnu.org/licenses/lgpl-3.0.html

bak
---

Script to make a backup of a folder and a mysql database, compress the result
using timestamp as part of the name.

Usefull when you don’t have a VCS for a project, or doing a quick backup of an
existing website.

**Installation**

Copy the *bak* directory outside of your project. Edit and rename
*bak\_cfg.sample.sh* to *bak\_cfg.sh* for configuration. Make *bak.sh* and
*restore.sh* executables by doing:

chmod +x bak.sh

chmod +x restore.sh

**Usage**

To create a backup, navigate to the script directory, and run:

./bak.sh

Two files will be created on the script directory, using the designated name,
date and time (for designated timezone). One of them ending in .files.tar.gz
with all files, and another ending in .sql.tar.gz, with database sql dump. You
should place the script directory somewhere that is not accesible by users, or
restrict download of files with .htaccess file.

To restore a backup, navigate to the script directory, and run:

./restore.sh \<backup\_filename\>

Use the backup filename without .files.tar.gz or .sql.tar.gz, and the script
will try to restore both of them. If you specify instead one of those files,
only that one will be restored. This process will completely erase the content
of the target directory and drop all tables of the database, so be carefull of
what you’re doing (if unsure, first launch a backup).

 
