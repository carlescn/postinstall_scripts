#!/usr/bin/env bash

###################################################################
# Script Name : 11_setup_dnf_rpmfusion.sh
# Description : Add rpmfusion repositories.
# Args        : None
# Author      : CarlesCN
# E-mail      : carlesbioinformatics@gmail.com
# License     : GNU General Public License v3.0
###################################################################

set -e -u -o pipefail


# Add rpmfusion-free and rpmfusion-nonfree repositories
dnf install "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
dnf install "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"

dnf groupupdate core
