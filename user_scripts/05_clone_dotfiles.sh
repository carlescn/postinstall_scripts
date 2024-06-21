#!/usr/bin/env bash

###################################################################
# Script Name : 05_cone_dotfiles.sh
# Description : Clones my dotfiles github repo and checks out files,
#               backing up when existing.
# Args        : None
# Author      : CarlesCN
# E-mail      : carlesbioinformatics@gmail.com
# License     : GNU General Public License v3.0
###################################################################

set -e -u -o pipefail


# Define repo and paths
repo='git@github.com:carlescn/dotfiles.git'
gitdir="$HOME/.dotfiles/"
worktree="$HOME"
backupdir="$HOME/dotfiles_backup"


# Functions
function dotfiles {
  /usr/bin/git --git-dir="$gitdir" --work-tree="$worktree" "$@"
}

function backup { # relative path, worktree, backupdir
  if [ ! -f "$2/$1" ] && [ ! -d "$2/$1" ]; then return; fi
  echo "Backing up $1"
  mkdir -p "$(dirname "$3/$1")"
  mv "$2/$1" "$3/$1"
}
export -f backup


# Clone repo
echo "[Cloning repository '$repo']"
git clone --bare "$repo" "$gitdir"

# Config repo
# Track remote branches (doesn't work out of the box with bare repositories)
dotfiles config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*"
# Don't show untracked files
dotfiles config status.showUntrackedFiles no

# Backup files before checkout
echo "Backing up pre-existing dotfiles into '$backupdir'"
dotfiles ls-tree -r main --name-only | xargs -I{} sh -c "backup {} $worktree $backupdir"

# Checkout files
mkdir -p "$worktree"
dotfiles checkout

# Clone submodules
echo -e "\n[Cloning submodules]"
cd "$worktree"
dotfiles submodule init

# Backup files if submodule update failed
if [ -f .gitmodules ]; then
  echo "Backing up pre-existing submodules into '$backupdir'"
  cat .gitmodules | awk '/\s+path = / {print $3}' | xargs -I{} sh -c "backup {} $worktree $backupdir"
fi

dotfiles submodule update


# Alias
echo -e '\nDone!'
echo 'You can now interact with your local repo using the following command (consider creating an alias):'
echo "git --git-dir=$gitdir --work-tree=$worktree"
