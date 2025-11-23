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
add_repo_vscode
install_list+=('code')           # VS Code
dnf copr enable atim/lazygit -y
install_list+=('lazygit')        # TUI git helper
install_list+=('shellcheck')     # Bash linter
install_list+=('android-tools')  # ADB and other Android tools
install_list+=('gcc')
install_list+=('make')
install_list+=('avrdude')        # tool for programming Atmel AVR MCUs

#[Desktop]
# i3 windows manager
install_list+=('i3')           # tiling windows manager
install_list+=('i3blocks')     # run scripts to diplay info in i3bar
dnf copr enable tokariew/i3lock-color -y
install_list+=('i3lock-color') # lock screen

# i3/i3blocks and dependencies
remove_list+=('default-fonts-other-sans')  # some of these fonts collide with Nerd Fonts
install_list+=('blueman')                  # provides bluetooth tray applet
install_list+=('dunst')                    # notification daemon
install_list+=('pavucontrol')              # [volume] gui for controlling pulseaudio volume
install_list+=('xset')                     # set X display preferences
  # sysstat    [cpu]: in section System monitoring
  # lm_sensors [temp_cpu]: in section System monitoring
  # nvidia-smi [temp_gpu]: run 20_nvidia_driver_470xx.sh
  # nordvpn    [nordvpn]: see Internet section

# Some rice
install_list+=('feh')                   # display desktop wallpaper
install_list+=('fastfetch')             # system report
install_list+=('picom')                 # composer (enable transparency)
install_list+=('rofi')                  # app launcher
install_list+=('lxappearance')          # tool to manage GTK themes
install_list+=('qt5ct')                 # tool to manage QT themes
install_list+=('grub-customizer')       # tool to customize grub apperarance
install_list+=('flat-remix-gtk3-theme') # GTK3 theme
install_list+=('flat-remix-gtk4-theme') # GTK4 theme

# Terminal tools
install_list+=('kitty')     # Terminal emulator
install_list+=('yazi')      # TUI file manager
dnf copr enable lihaohong/yazi -y
install_list+=('fzf')       # Fuzzy finder
install_list+=('fd-find')   # Better find
install_list+=('bat')       # Better cat
install_list+=('eza')       # Better ls
install_list+=('zoxide')    # Better cd

# Desktop apps
install_list+=('dconf-editor') # Gnome settings editor
install_list+=('thunar')       # GTK file manager
install_list+=('maim')         # take screenshots
install_list+=('libreoffice')  # office suite
install_list+=('cheese')       # webcam app
install_list+=('remmina')      # remote desktop client

#[Games]
install_list+=('steam')      # Steam
install_list+=('pcsxr')      # PSX emulator
install_list+=('zsnes')      # SNES emulator
install_list+=('jstest-gtk') # tool to test gamepad

#[Internet]
dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
install_list+=('brave-browser')  # Browser
install_list+=('thunderbird')    # E-mail

#[Localization]
# Spell checker
install_list+=('hunspell-en')    # English
install_list+=('hyphen-en')      # English
install_list+=('hunspell-es-ES') # Spanish
install_list+=('hyphen-es')      # Spanish
install_list+=('hunspell-ca')    # Catalan
install_list+=('hyphen-ca')      # Catalan

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

#[Tools]
install_list+=('cronie-anacron') # anacron - automate tasks
install_list+=('p7zip')          # compress / extract 7z
install_list+=('yq')             # yaml parser
install_list+=('pdftk-java')     # pdf tools
install_list+=('ddccontrol')     # tool to control monitor
install_list+=('xev')            # diplay X11 events
install_list+=('testdisk')       # tool to recover files
install_list+=('tft-server')     # tftp server (to serve router images)

#[Virtualization]
# TODO: review / document this
install_list+=('bridge-utils')
install_list+=('libvirt')
install_list+=('virt-install')
install_list+=('qemu-kvm')
install_list+=('libvirt-devel')
install_list+=('virt-top')
install_list+=('libguestfs-tools')
install_list+=('guestfs-tools')
install_list+=('virt-manager')

# Docker
dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
install_list+=('docker-ce')
install_list+=('docker-ce-cli')
install_list+=('containerd.io')
install_list+=('docker-buildx-plugin')
install_list+=('docker-compose-plugin')
dnf config-manager addrepo --from-repofile=https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo
install_list+=('nvidia-container-toolkit')

#[Other]
install_list+=('java-21-openjdk') # needed to run AutoFirma app


## INSTALL ##

# Remove and install packages as defined in list
dnf --refresh shell <(echo -e "${remove_list[*]}\n${install_list[*]}")
