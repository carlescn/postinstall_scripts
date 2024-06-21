#!/usr/bin/env bash

###################################################################
# Script Name : 10_setup_local_crontab.sh
# Description : Installs a local crontab file that runs anacron hourly for the current user
# Args        : None
# Author      : CarlesCN
# E-mail      : carlesbioinformatics@gmail.com
# License     : GNU General Public License v3.0
###################################################################

set -u -o pipefail # no -e because must let crontab fail if it's empty

task='@hourly /usr/sbin/anacron -s -t $HOME/.anacron/anacrontab -S $HOME/.anacron/spool'
temp_file='./.crontab.tmp'

# backup crontab (exits with code 1 if empty)
crontab -l 2>/dev/null > "$temp_file"
# append new line
echo "$task" >> "$temp_file"
# install new crontab
crontab "$temp_file"

rm "$temp_file"

echo "crontab updated:"
crontab -l
