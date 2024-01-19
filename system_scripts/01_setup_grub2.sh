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


# Force showing boot menu
grub2-editenv - unset menu_auto_hide


# Change default options
cp /etc/default/grub /etc/default/grub.bk

awk '/^GRUB_TIMEOUT/         { sub("5", "2") }     # lower timeout
     /^GRUB_TERMINAL_OUTPUT/ { printf "#" }        # prevent low resolution
     /^GRUB_CMDLINE_LINUX=/  { gsub(" rhgb", "") } # disable graphical boot screen (Fedora logo)
     {print}
    ' /etc/default/grub.bk > /etc/default/grub

grub2-mkconfig -o /etc/grub2.cfg
