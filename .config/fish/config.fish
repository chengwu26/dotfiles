set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_STATE_HOME "$HOME/.local/state"
set -gx XDG_CACHE_HOME "$HOME/.cache"

set -l vim env --argv0=vim nvim
set -gx EDITOR $vim
set -gx VISUAL $vim
set -gx MANPAGER "$vim +Man!"

# Fix XDG Base Directory
set -gx CARGO_HOME "$XDG_DATA_HOME/cargo"
set -gx RUSTUP_HOME "$XDG_DATA_HOME/rustup"

set -gx PYTHON_HISTORY "$XDG_STATE_HOME/python_history"

set -gx DOCKER_CONFIG "$XDG_CONFIG_HOME/docker"

set -gx NPM_CONFIG_INIT_MODULE "$XDG_CONFIG_HOME/npm/config/npm-init.js"
set -gx NPM_CONFIG_CACHE "$XDG_CACHE_HOME/npm"
set -gx NPM_CONFIG_TMP "$XDG_RUNTIME_DIR/npm"

status is-interactive || return
# ---- INTERACTIVE CONFIG -----

# install theme
set -l theme "$__fish_config_dir/themes/Catppuccin Mocha.theme"
set -l url 'https://raw.githubusercontent.com/catppuccin/fish/main/themes/Catppuccin%20Mocha.theme'
test -f $theme || curl -sSL --create-dirs $url -o $theme && fish_config theme choose 'Catppuccin Mocha'

# keybind
set fish_sequence_key_delay_ms 300
bind -M insert -m default j,k backward-char repaint
set fish_key_bindings fish_vi_key_bindings

# integrate
zoxide init --cmd cd fish | source
fzf --fish | source
set -x FZF_DEFAULT_OPTS '--height ~40% --tmux bottom --border'

alias so="source $__fish_config_dir/config.fish"
alias c='clear'
alias ff='fastfetch'
alias ffm='ffmpeg -hide_banner'

alias vi='env --argv0=vi nvim'
alias vim="$vim"

alias dot='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias ga='git add'
alias gd='git diff'
