## Zsh Environment Setup
##
## XDG_CONFIG_HOME  User specified config files
## XDG_CACHE_HOME   Temporary data
## XDG_DATA_HOME    Program created data files
## XDG_STATE_HOME   Program state -- logs, history, etc.

export EDITOR=nvim
export VISUAL=nvim

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export SHELL_SESSIONS_DISABLE=1
export R_PROFILE_USER="$XDG_CONFIG_HOME/R/Rprofile"
