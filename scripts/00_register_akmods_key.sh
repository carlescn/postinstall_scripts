#!/usr/bin/env bash

###################################################################
# Script Name : 00_register_akmods_key.sh
# Description : Registers the akmods default key to your Secure Boot
#             : enabled system to be able to load signed kernel modules.
# Args        : None
# Author      : CarlesCN
# E-mail      : carlesbioinformatics@gmail.com
# License     : GNU General Public License v3.0
###################################################################

set -e -u -o pipefail

if [[ $EUID -ne 0 ]]; then echo "Please run as root"; exit 1; fi


# Run only the first time
basename "$0" >> "$(dirname "$0")/jobs.deny"


cat <<EOF

WARNING: this script will REBOOT your system and boot into UEFI so you can register the new key.
You only need to run this script if all of the following applies:
- your system has Secure Boot enabled
- you need to load kernel modules signed by akmods (ex: propietary nVidia drivers)
- your default akmods key is not already registered in your system

Note: this script will be run only once by run-parts.
To allow running it again, remove the corresponding line from the file 'jobs.deny'.

EOF

read -p 'Run anyway? [y/N] ' -n 1 -r
echo ''

if [[ $REPLY =~ ^[Yy]$ ]]; then
  mokutil --import /etc/pki/akmods/certs/public_key.der
  systemctl reboot
else
  echo "Cancelled"
fi
