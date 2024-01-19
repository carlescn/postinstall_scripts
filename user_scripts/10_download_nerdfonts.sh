#!/usr/bin/env bash

###################################################################
# Script Name : 10_download_nerdfonts.sh
# Description : Downloads some Nerd Fonts and installs them under ~/.local/share/fonts
#             : Fonts credit: https://github.com/ryanoasis/nerd-fonts
# Args        : None
# Author      : CarlesCN
# E-mail      : carlesbioinformatics@gmail.com
# License     : GNU General Public License v3.0
###################################################################

set -e -u -o pipefail


# Define fonts to download (see https://github.com/ryanoasis/nerd-fonts/releases/latest)
fonts=()
fonts+=('CommitMono')
fonts+=('DejaVuSansMono')
fonts+=('JetBrainsMono')
fonts+=('LiberationMono')
fonts+=('SourceCodePro')

# Define paths
fonts_dir="$HOME/.local/share/fonts"
tmp_dir='nerdfonts_tmp'

base_url='https://github.com/ryanoasis/nerd-fonts/releases/latest/download/'


# Check directories
if [[ ! -d "$fonts_dir" ]]; then
  echo "Destination directory '$fonts_dir' does not exist! Can't continue!"
  exit 1
fi
if [[ -d "$tmp_dir" ]]; then
  echo "Temporal directory '$tmp_dir' already exists! Exiting to prevent data loss"
  exit 1
fi


# Download, untar and move files
echo "Making temporal directory '$tmp_dir' for downloading and uncompressing files"
mkdir "${tmp_dir}"

echo "Downloading and uncompressing files..."
for font in "${fonts[@]}"; do
  file_name="$font.tar.xz"
  wget -P "$tmp_dir/" "$base_url/$file_name"
  tar -xf "$tmp_dir/$file_name" -C "$tmp_dir"
done

echo "Moving files into destination directory '$fonts_dir'"
for ext in 'ttf' 'otf'; do
  mv "$tmp_dir/"*".$ext" "$fonts_dir/" || true # don't error if there are no files to move!
done

echo "Removing temporal directory '${tmp_dir}'"
rm -rf "$tmp_dir"


# Update fonts cache
echo "Updating the fonts cache..."
fc-cache

