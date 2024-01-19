#!/usr/bin/env bash

###################################################################
# Script Name : 01_enable_ssh.sh
# Description : Enables ssh to login remotely.
# Args        : None
# Author      : CarlesCN
# E-mail      : carlesbioinformatics@gmail.com
# License     : GNU General Public License v3.0
###################################################################

set -e -u -o pipefail


systemctl enable sshd
systemctl start sshd
