#!/usr/bin/env bash

###################################################################
# Script Name : run_system_scripts.sh
# Description : Runs all the scripts using run-parts.
# Args        : None
# Author      : CarlesCN
# E-mail      : carlesbioinformatics@gmail.com
# License     : GNU General Public License v3.0
###################################################################

set -e -u -o pipefail

if [[ $EUID -ne 0 ]]; then echo "Please run as root"; exit 1; fi


path="${PWD}/system_scripts/"

echo ''
echo 'WARNING: this will run the following scripts with root privileges:'
run-parts --test "${path}"
echo ''

read -p 'Are you sure? [y/N] ' -n 1 -r
echo ''

if [[ $REPLY =~ ^[Yy]$ ]]; then
  run-parts "${path}"
else
  echo "Cancelled"
fi
