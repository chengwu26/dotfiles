#!/usr/bin/env bash

set -e
command -v pacman > /dev/null || { echo 'This script only supports Arch Linux'; exit 1; }

function info() {
  printf '\e[32m=== INFO: %s ===\e[0m\n' "$1"
}

function repo2url() {
  echo "https://github.com/chengwu26/${1}.git"
}

function gitclone() {
  local repo="$1"
  local dir="$2"
  local bare="$3"

  local cmd=(git clone)
  [[ $bare == true ]] && cmd+=(--bare)
  cmd+=("$(repo2url "$repo")" "$dir")

  [[ -d "$dir" ]] && rm -rf "$dir"
  "${cmd[@]}"
}

declare -a apps=(
  sudo man-db man-pages openssh base-devel
  zsh fzf zoxide tmux tree fastfetch ffmpeg hyperfine ripgrep fd
  uv pyright rustup git
  neovim tree-sitter-cli yarn npm unzip inotify-tools
)

info 'Initialize pacman keyring'
pacman-key --init
pacman-key --populate archlinux

info 'Install apps'
pacman -Syu --noconfirm --needed "${apps[@]}"

info 'Install rust toolchain'
rustup toolchain install stable

info 'Clone dotfiles repo'
gitclone dotfiles ~/.dotfiles true
git --git-dir=${HOME}/.dotfiles --work-tree=${HOME} reset --hard

info 'Clone nvim repo'
gitclone nvim "${HOME}/.config/nvim"
