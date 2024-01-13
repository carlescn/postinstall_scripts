#!/usr/bin/env bash

###################################################################
# Script Name : 50_install_i3wm.sh
# Description : Install i3wm and the tools used to rice it.
# Args        : None
# Author      : CarlesCN
# E-mail      : carlesbioinformatics@gmail.com
# License     : GNU General Public License v3.0
###################################################################

set -e -u -o pipefail

if [[ $EUID -ne 0 ]]; then echo "Please run as root"; exit 1; fi


install_pkgs=()
remove_pkgs=()

# i3 windows manager
install_pkgs+=("i3")    # i3 window manager

# i3blocks
install_pkgs+=("i3blocks") # run scripts to diplay info in i3bar
install_pkgs+=("fontawesome-fonts-all") # fonts to display icons
remove_pkgs+=("default-fonts-other-sans") # some of these fonts collide with fontawesome

# Some rice
install_pkgs+=("rofi")  # app launcher
install_pkgs+=("lxappearance") # tool to manage gtk themes
install_pkgs+=("feh")   # display desktop wallpaper
install_pkgs+=("picom") # composer (enable transparency)


# Run DNF
dnf remove "${remove_pkgs[@]}"
dnf install "${install_pkgs[@]}"
