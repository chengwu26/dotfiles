# ╭──────────────────────────────────────────────────────────╮
# │                Environment Variable                      │
# ╰──────────────────────────────────────────────────────────╯

# Basic
export EDITOR=nvim
export VISUAL=nvim
export MANPAGER='nvim +Man!'
export MANWIDTH=$((COLUMNS - 3))
trap 'MANWIDTH=$((COLUMNS - 3))' WINCH

export DEV_ENV=true

# XDG Base Directories
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"

# Apps
## Rust
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"

## Python
export PYTHON_HISTORY="$XDG_STATE_HOME/python_history"

## Docker
export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"

## npm
export NPM_CONFIG_INIT_MODULE="$XDG_CONFIG_HOME/npm/config/npm-init.js"
export NPM_CONFIG_CACHE="$XDG_CACHE_HOME/npm"
export NPM_CONFIG_TMP="$XDG_RUNTIME_DIR/npm"


# ------------------------------------------------------------
[[ -o interactive ]] || return

# ╭──────────────────────────────────────────────────────────╮
# │                        Plugins                           │
# ╰──────────────────────────────────────────────────────────╯

ZINIT_HOME=$XDG_DATA_HOME/zinit/zinit.git
[[ -d $ZINIT_HOME ]] || mkdir -p ${ZINIT_HOME:h}
[[ -d $ZINIT_HOME/.git ]] || git clone https://github.com/zdharma-continuum/zinit.git $ZINIT_HOME
source $ZINIT_HOME/zinit.zsh

zinit ice pick'themes/catppuccin_mocha-zsh-syntax-highlighting.zsh'
zinit light catppuccin/zsh-syntax-highlighting
zinit light zsh-users/zsh-syntax-highlighting
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions

zinit light Aloxaf/fzf-tab
bindkey '^R' fzf-history-widget

zinit ice wait lucid
zinit light hlissner/zsh-autopair

function zvm_config() {
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
  ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
}
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode


# ╭──────────────────────────────────────────────────────────╮
# │                         Options                          │
# ╰──────────────────────────────────────────────────────────╯

bindkey -v
bindkey -M vicmd 'j' down-line-or-search
bindkey -M vicmd 'k' up-line-or-search

# History
HISTSIZE=5000
SAVEHIST=$HISTSIZE
HISTDUP=erase
HISTFILE=$XDG_STATE_HOME/zsh/history
[[ -d ${HISTFILE:h} ]] || mkdir -p "${HISTFILE:h}"

setopt interactive_comments
setopt append_history share_history
setopt hist_ignore_space hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_save_no_dups
setopt hist_find_no_dups

# Completion
autoload -Uz compinit
[[ -d $XDG_CACHE_HOME/zsh ]] || mkdir -p "$XDG_CACHE_HOME/zsh"
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no

# Integrations
eval "$(zoxide init --cmd cd zsh)"
eval "$(fzf --zsh)"
export FZF_DEFAULT_OPTS='--height ~40% --tmux bottom --border'


# ╭──────────────────────────────────────────────────────────╮
# │                         Prompt                           │
# ╰──────────────────────────────────────────────────────────╯
local blue='%F{#89B4FA}'
local sapphire='%F{#74C7EC}'
local lavender='%F{#B4BEFE}'
local green='%F{#A6E3A1}'
local red='%F{#F38BA8}'
local yellow='%F{#F9E2AF}'

function preexec() {
  CMD_START_TIME=$SECONDS
}
function precmd() {
  CMD_RUNTIME=$((SECONDS - CMD_START_TIME))
  RPROMPT="%F{#F9E2AF}${CMD_RUNTIME}s%f"
}

PROMPT="
${blue}%n ${lavender}%~
${green}%(?..${red}%? )%(!.!❯.❯) "

print -P "${yellow}$0 ${blue}$(uptime -p | cut -c 4-) ${lavender}$(uname -r)"


# ╭──────────────────────────────────────────────────────────╮
# │                        Aliases                           │
# ╰──────────────────────────────────────────────────────────╯
# Basic
alias so="source ${ZDOTDIR:-$HOME}/.zshrc"
alias c='clear'
alias ls='ls --color'
alias ll='ls -Al --color'
alias ff='fastfetch'

alias ffmpeg='ffmpeg -hide_banner'

# Git
alias dot='git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME"'

alias ga='git add'
alias gd='git diff'
