#!/usr/bin/env bash

###################################################################
# Script Name : 19_dnf_update.sh
# Description : Run dnf update.
# Args        : None
# Author      : CarlesCN
# E-mail      : carlesbioinformatics@gmail.com
# License     : GNU General Public License v3.0
###################################################################

set -e -u -o pipefail

if [[ $EUID -ne 0 ]]; then echo "Please run as root"; exit 1; fi


dnf upgrade --refresh
