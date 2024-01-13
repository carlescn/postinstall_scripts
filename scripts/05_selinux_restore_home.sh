#!/usr/bin/env bash

###################################################################
# Script Name : 05_selinux_restore_home.sh
# Description : Restores files default SELinux security context recursively on /home.
# Args        : None
# Author      : CarlesCN
# E-mail      : carlesbioinformatics@gmail.com
# License     : GNU General Public License v3.0
###################################################################

set -e -u -o pipefail

if [[ $EUID -ne 0 ]]; then echo "Please run as root"; exit 1; fi


cat <<EOF

WARNING: this might take some time!
This will recursively restore the default SELinux security context on all files in the /home directory.
It is recommended to do this only if you ported your /home directory from some system without selinux enforcing.

EOF

read -p 'Run anyway? [y/N] ' -n 1 -r
echo ''

if [[ $REPLY =~ ^[Yy]$ ]]; then
  restorecon -vr /home
else
  echo "Cancelled"
fi
