#!/usr/bin/env bash

###################################################################
# Script Name : 50_install_software.sh
# Description : Installs some packages (and repos when necessary).
# Args        : None
# Author      : CarlesCN
# E-mail      : carlesbioinformatics@gmail.com
# License     : GNU General Public License v3.0
###################################################################

set -e -u -o pipefail


dnf_list=()


## REPOS ##

architecture=$(uname -m)

function add_repo {
	rpm -v --import "$2"
	dnf config-manager --add-repo "$1"
}

function add_repo_brave_browser {
	url_repo='https://brave-browser-rpm-release.s3.brave.com'
	url_key='https://brave-browser-rpm-release.s3.brave.com/brave-core.asc'

	add_repo "${url_repo}/${architecture}" "${url_key}"
}

function add_repo_nordvpn {
	# NOTE: alternatively, you can run the official script instead:
	# https://downloads.nordcdn.com/apps/linux/install.sh

	url_repo='https://repo.nordvpn.com/yum/nordvpn/centos'
	url_key='https://repo.nordvpn.com/gpg/nordvpn_public.asc'

	add_repo "${url_repo}/${architecture}" "${url_key}"
}

function add_repo_vscode {
  # Define URLs
  url_repo='https://packages.microsoft.com/yumrepos/vscode'
  url_key='https://packages.microsoft.com/keys/microsoft.asc'

  rpm -v --import "${url_key}"

  cat <<EOF > /etc/yum.repos.d/vscode.repo
[vscode]
name=Visual Studio Code
baseurl=$url_repo
enabled=1
gpgcheck=1
gpgkey=$url_key
EOF
}


## PACKAGES ##

# [Acacdemic]

dnf_list+=("install mendeleydesktop") # reference management


# [Backup]

dnf_list+=("install rsync")
dnf_list+=("install rclone") # backup to cloud services


# [Code]

# VSCode
add_repo_vscode
dnf_list+=("install code")


# [Desktop]

# Gnome settings editor
dnf_list+=("install dconf-editor")

# i3 windows manager
dnf_list+=("install i3")

# i3blocks
dnf_list+=("install i3blocks")                 # run scripts to diplay info in i3bar
dnf_list+=("install fontawesome-fonts-all")    # fonts to display icons
dnf_list+=("remove default-fonts-other-sans")  # some of these fonts collide with fontawesome

# i3blocklets dependencies
dnf_list+=("install sysstat")     # [cpu] provides sar and other reporting tools
dnf_list+=("install lm_sensors")  # [temp_cpu] provides tools for monitoring hardware
dnf_list+=("install pavucontrol") # [volume] gui for controlling pulseaudio volume
# [temp_gpu] run 20_nvidia_driver_470xx.sh to install nvidia-smi (it is version specific depending on hardware).
# [nordvpn]  see Internet section

# Some rice
dnf_list+=("install feh")           # display desktop wallpaper
dnf_list+=("install lxappearance")  # tool to manage gtk themes
dnf_list+=("install neofetch")      # system report
dnf_list+=("install picom")         # composer (enable transparency)
dnf_list+=("install rofi")          # app launcher


# [Games]

dnf_list+=("install steam")  # Steam
dnf_list+=("install pcsxr")  # PSX emulator
dnf_list+=("install zsnes")  # SNES emulator


# [Internet]

# Browser
add_repo_brave_browser
dnf_list+=("install brave-browser")

# E-mail
dnf_list+=("install thunderbird")

# VPN
add_repo_nordvpn
dnf_list+=("install nordvpn")


# [Localization]

# Spell checker
dnf_list+=("install hunspell-en")
dnf_list+=("install hyphen-en")
dnf_list+=("install hunspell-es-ES")
dnf_list+=("install hyphen-es")
dnf_list+=("install hunspell-ca")
dnf_list+=("install hyphen-ca")


# [Multimedia]

dnf_list+=("install audacity-freeworld")  # audio editor
dnf_list+=("install gimp")                # image editor
dnf_list+=("install avidemux")            # video editor
dnf_list+=("install vlc")                 # video player


# [Security]

dnf_list+=("install seahorse")


## INSTALL ##

# Remove and install packages as defined in list
dnf --refresh shell <(IFS=$'\n'; echo "${dnf_list[*]}")
