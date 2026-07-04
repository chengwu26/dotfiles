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
  sudo man-db man-pages openssh base-devel unzip inotify-tools
  fish fzf zoxide tmux tree fastfetch ffmpeg hyperfine ripgrep fd tldr
  clang lldb rustup uv pyright git
  neovim tree-sitter-cli npm
)

info 'Initialize pacman keyring'
pacman-key --init
pacman-key --populate archlinux

info 'Install apps'
pacman -Syu --noconfirm --needed "${apps[@]}"

info 'Clone repositories'
gitclone dotfiles ~/.dotfiles true
git --git-dir="${HOME}/.dotfiles" --work-tree="${HOME}" reset --hard
gitclone nvim "${XDG_CONFIG_HOME:-${HOME}/.config}/nvim"

info 'Install rust toolchain'
exec fish
rustup default stable
