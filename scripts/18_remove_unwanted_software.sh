#!/usr/bin/env bash

###################################################################
# Script Name : 18_remove_unwanted_software.sh
# Description : Remove unwanted repos and packages.
# Args        : None
# Author      : CarlesCN
# E-mail      : carlesbioinformatics@gmail.com
# License     : GNU General Public License v3.0
###################################################################

set -e -u -o pipefail


# General rmpfusion-nonfree repo was added by 01_setup_dnf_rpmfusion.sh, so these are innecessary:
rm -f /etc/yum.repos.d/rpmfusion-nonfree-steam.repo
rm -f /etc/yum.repos.d/rpmfusion-nonfree-nvidia-driver.repo

# Remove Google Chrome and its repo
dnf repolist | grep -q 'google-chrome' && dnf repository-packages google-chrome remove
rm -f /etc/yum.repos.d/google-chrome.repo

# Remove copr repo for PyCharm (if exists)
dnf copr list | grep -q 'phracek/PyCharm' && dnf copr remove phracek/PyCharm


# Remove other unwanted packages
remove_packages=()
remove_packages+=("firefox")
remove_packages+=("gnome-boxes")
remove_packages+=("gnome-calendar")
remove_packages+=("gnome-clocks")
remove_packages+=("gnome-contacts")
remove_packages+=("gnome-maps")
remove_packages+=("gnome-photos")
remove_packages+=("gnome-tour")
remove_packages+=("gnome-weather")
remove_packages+=("ibus-anthy")
remove_packages+=("ibus-hangul")
remove_packages+=("ibus-m17n")
remove_packages+=("ibus-typing-booster")
remove_packages+=("ibus-libpinyin")
remove_packages+=("ibus-libzhuyin")
remove_packages+=("libreoffice*")
remove_packages+=("mediawriter")
remove_packages+=("rhythmbox")
remove_packages+=("simple-scan")
remove_packages+=("totem")

dnf remove "${remove_packages[@]}"
