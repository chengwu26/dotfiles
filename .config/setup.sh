#!/bin/bash

if [[ -f /etc/os-release ]]; then
  source /etc/os-release
  if [[ $ID != 'arch' ]]; then
    echo "This script only supports Arch Linux, but $NAME"
    exit 1
  fi
else
  echo "Unknown OS"
  exit 1
fi

apps=(
  sudo tmux tree
  zsh fzf zoxide
  man-db man-pages
  uv pyright rustup openssh
  fastfetch ffmpeg bat hyperfine
  neovim git tree-sitter-cli gcc yarn npm ripgrep fd unzip inotify-tools 
)

pacman -Syyu --noconfirm "${apps[@]}"
exec zsh

function repo2url() {
  echo "https://github.com/chengwu26/${1}.git"
}

rustup toolchain install stable

git clone --bare "$(repo2url dotfiles)" "${HOME}/.dotfiles"
git --git-dir="${HOME}/.dotfiles" --work-tree="${HOME}" reset --hard
source "${HOME}/.zshrc"

git clone "$(repo2url nvim)" "${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
