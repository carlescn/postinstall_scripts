#!/usr/bin/env bash

###################################################################
# Script Name : 20_install_nvidia_driver_470xx.sh
# Description : Install nvidia driver (version 470xx for old hardware).
# Args        : None
# Author      : CarlesCN
# E-mail      : carlesbioinformatics@gmail.com
# License     : GNU General Public License v3.0
###################################################################

set -e -u -o pipefail

if [[ $EUID -ne 0 ]]; then echo "Please run as root"; exit 1; fi


install_pkgs=()

# Nvidia driver
# Note: on Secure Boot enabled systems, you need to register akmods key first, run 00_register_akmods_key.sh.
install_pkgs+=("akmod-nvidia-470xx")
install_pkgs+=("xorg-x11-drv-nvidia-470xx-cuda") # provides nvidia-smi for monitoring temperature

# Enable hardware video acceleration
install_pkgs+=("vdpauinfo")
install_pkgs+=("libva-utils")
install_pkgs+=("libva-vdpau-driver")


sudo dnf install "${install_pkgs[@]}"
