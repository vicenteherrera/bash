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

Copy the *bak *directory outside of your project. Edit and rename
*bak\_cfg.sample.sh* to *bak\_cfg.sh* for configuration. Make *bak.sh* and
*restore.sh *executables by doing:

chmod +x bak.sh

chmod +x restore.sh

**Usage**

Invoke like:

./bash.sh

./restore.sh \<backup\_filename\>
