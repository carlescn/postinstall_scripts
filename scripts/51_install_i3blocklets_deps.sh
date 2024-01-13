#!/usr/bin/env bash

###################################################################
# Script Name : 51_install_i3blocklets_deps.sh
# Description : Install dependencies for i3blocklets commands.
# Args        : None
# Author      : CarlesCN
# E-mail      : carlesbioinformatics@gmail.com
# License     : GNU General Public License v3.0
###################################################################

set -e -u -o pipefail

if [[ $EUID -ne 0 ]]; then echo "Please run as root"; exit 1; fi


install_pkgs=()

# volume
install_pkgs+=("pavucontrol") # gui for controlling pulseaudio volume

# cpu
install_pkgs+=("sysstat") # provides sar and other reporting tools

# temp_cpu
install_pkgs+=("lm_sensors") # provides tools for monitoring hardware

# temp_gpu: run 20_nvidia_driver_470xx.sh to install nvidia-smi (it is version specific depending on hardware).
# nordvpn: run 30_nordvpn.sh (it needs activating a third party repo).

# Run DNF
dnf install "${install_pkgs[@]}"
