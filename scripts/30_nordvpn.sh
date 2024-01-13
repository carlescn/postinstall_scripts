#!/usr/bin/env bash

###################################################################
# Script Name : 30_nordvpn.sh
# Description : Install NordVPN repository and package.
# Args        : None
# Author      : CarlesCN
# E-mail      : carlesbioinformatics@gmail.com
# License     : GNU General Public License v3.0
###################################################################

set -e -u -o pipefail

if [[ $EUID -ne 0 ]]; then echo "Please run as root"; exit 1; fi


# NOTE: alternatively, you can run the official script instead:
# https://downloads.nordcdn.com/apps/linux/install.sh


# Define URLs
url_key='https://repo.nordvpn.com/gpg/nordvpn_public.asc'
url_repo='https://repo.nordvpn.com/yum/nordvpn/centos/'
architecture=$(uname -m)

# Import key and install repository
rpm -v --import "${url_key}"
dnf config-manager --add-repo "${url_repo}/${architecture}"

# Install package
dnf install nordvpn
