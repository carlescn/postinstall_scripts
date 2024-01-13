#!/usr/bin/env bash

###################################################################
# Script Name : 10_setup_dnf_speedup.sh
# Description : Speed up dnf.
# Args        : None
# Author      : CarlesCN
# E-mail      : carlesbioinformatics@gmail.com
# License     : GNU General Public License v3.0
###################################################################

set -e -u -o pipefail

if [[ $EUID -ne 0 ]]; then echo "Please run as root"; exit 1; fi


echo "max_parallel_downloads=10" > /etc/dnf/dnf.conf
echo "fastestmirror=True" > /etc/dnf/dnf.conf
