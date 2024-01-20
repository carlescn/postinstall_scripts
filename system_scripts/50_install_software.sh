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

install_list=('install')
remove_list=('remove')


#[Academic]
install_list+=('mendeleydesktop') # reference management

#[Backup]
install_list+=('rsync')  # sync files
install_list+=('rclone') # backup to cloud services

#[Code]
install_list+=('code'); add_repo_vscode # VS Code
install_list+=('gitui')                 # TUI git helper
install_list+=('shellcheck')            # Bash linter

#[Desktop]
# i3 windows manager
install_list+=('i3')        # tiling windows manager
install_list+=('i3blocks')  # run scripts to diplay info in i3bar

# i3/i3blocks and dependencies
remove_list+=('default-fonts-other-sans')  # some of these fonts collide with Nerd Fonts
install_list+=('blueman')                  # provides bluetooth tray applet
install_list+=('pavucontrol')              # [volume] gui for controlling pulseaudio volume
  # sysstat    [cpu]: in section System monitoring
  # lm_sensors [temp_cpu]: in section System monitoring
  # nvidia-smi [temp_gpu]: run 20_nvidia_driver_470xx.sh
  # nordvpn    [nordvpn]: see Internet section

# Some rice
install_list+=('feh')           # display desktop wallpaper
install_list+=('lxappearance')  # tool to manage gtk themes
install_list+=('neofetch')      # system report
install_list+=('picom')         # composer (enable transparency)
install_list+=('rofi')          # app launcher

# Terminal apps
install_list+=('alacritty') # Terminal emulator
install_list+=('ranger')    # TUI file manager

# Desktop apps
install_list+=('dconf-editor') # Gnome settings editor
install_list+=('thunar')       # GTK file manager
install_list+=('maim')         # take screenshots

#[Games]
install_list+=('steam')  # Steam
install_list+=('pcsxr')  # PSX emulator
install_list+=('zsnes')  # SNES emulator

#[Internet]
install_list+=('brave-browser'); add_repo_brave_browser # Browser
install_list+=('thunderbird')                           # E-mail
install_list+=('nordvpn'); add_repo_nordvpn             # VPN

#[Localization]
# Spell checker
install_list+=('hunspell-en')
install_list+=('hyphen-en')
install_list+=('hunspell-es-ES')
install_list+=('hyphen-es')
install_list+=('hunspell-ca')
install_list+=('hyphen-ca')

#[Multimedia]
install_list+=('gimp')      # image editor
install_list+=('avidemux')  # video editor
install_list+=('vlc')       # video player

#[Security]
install_list+=('seahorse') # GUI key manager

#[System monitoring]
install_list+=('btop')        # TUI system monitor
install_list+=('hwinfo')      # hardware info
install_list+=('sysstat')     # provides sar and other reporting tools
install_list+=('lm_sensors')  # tools for monitoring hardware


## INSTALL ##

# Remove and install packages as defined in list
dnf --refresh shell <(echo -e "${remove_list[@]}\n${install_list[@]}")
