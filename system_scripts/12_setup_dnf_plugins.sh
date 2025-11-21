#!/usr/bin/env bash

###################################################################
# Script Name : 12_setup_dnf_plugins.sh
# Description : Installl dnf plugins and tools.
# Args        : None
# Author      : CarlesCN
# E-mail      : carlesbioinformatics@gmail.com
# License     : GNU General Public License v3.0
###################################################################

set -e -u -o pipefail

dnf install -y dnf-plugins-core dnf-utils rpmconf clean-rpm-gpg-pubkey remove-retired-packages
