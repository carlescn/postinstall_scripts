#!/usr/bin/env bash

###################################################################
# Script Name : 01_setup_grub2.sh
# Description : Modify grub2 to show menu screen and boot messages.
# Args        : None
# Author      : CarlesCN
# E-mail      : carlesbioinformatics@gmail.com
# License     : GNU General Public License v3.0
###################################################################

set -e -u -o pipefail

if [[ $EUID -ne 0 ]]; then echo "Please run as root"; exit 1; fi


# Force showing boot menu
grub2-editenv - unset menu_auto_hide

# Disable graphical boot screen (show boot messages instead of the Fedora logo)
cp /etc/default/grub /etc/default/grub.bk
awk '/GRUB_CMDLINE_LINUX=/ {gsub(" rhgb", "")}; {print}' /etc/default/grub.bk > /etc/default/grub
grub2-mkconfig -o /etc/grub2.cfg
