#!/usr/bin/env bash

###################################################################
# Script Name : 10_setup_local_crontab.sh
# Description : Installs a local crontab file that runs anacron hourly for the current user
# Args        : None
# Author      : CarlesCN
# E-mail      : carlesbioinformatics@gmail.com
# License     : GNU General Public License v3.0
###################################################################

set -e -u -o pipefail

crontab ../resources/crontab_anacron
