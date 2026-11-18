## Zsh User Config

## Keep PATH unique
typeset -U path PATH

## Allow comments in prompt
setopt INTERACTIVE_COMMENTS

## History
[[ -d "$XDG_STATE_HOME/zsh" ]] || mkdir -p "$XDG_STATE_HOME/zsh"
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_VERIFY
setopt SHARE_HISTORY

## Colors in ls
export CLICOLOR=1

# Homebrew path
if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv zsh)"
fi
if [ -f $HOME/local/bin/brew ]; then
    eval "$($HOME/local/bin/brew shellenv zsh)"
fi

# Local bin -- pipx, etc.
export PATH="$HOME/.local/bin:$PATH"

# TinyTex
export PATH="$HOME/Library/TinyTex/bin/universal-darwin/:$PATH"

# Rust env -- arf, etc.
if [ -f "$HOME/.cargo/env" ]; then
    source "$HOME/.cargo/env"
fi

## Aliases
alias gl='git log --decorate --graph --date=short --oneline --all'
alias gv='nvim +GV +"autocmd BufWipeout <buffer> qall"'


## Completion ----------------------------------------------
[[ -d "$XDG_CACHE_HOME/zsh" ]] || mkdir -p "$XDG_CACHE_HOME/zsh"
autoload -Uz compinit && compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
zstyle ':completion:*' use-cache on
zstyle ':completion:*' list-colors ''
setopt no_list_beep

# Case-insensitive completion (foo matches Foo)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Enable menu selection with Tab
zstyle ':completion:*' menu select

# Nice formatting for completion lists
zstyle ':completion:*:messages' format '%F{green}%d%f'
zstyle ':completion:*:warnings' format '%F{red}No matches%f'


## FZF -----------------------------------------------------
if command -v fzf &> /dev/null; then
  source <(fzf --zsh)  # keybindings + completion
fi

FZF_DEFAULT_OPTS=' --reverse --exact '
FZF_DEFAULT_OPTS+='--height 80% '
FZF_DEFAULT_OPTS+="--preview 'cat {}' "
FZF_DEFAULT_OPTS+='--preview-window hidden '
FZF_DEFAULT_OPTS+='--bind=f2:toggle-preview '
FZF_DEFAULT_OPTS+='--bind=ctrl-a:select-all '
FZF_DEFAULT_OPTS+='--bind=ctrl-u:deselect-all '
FZF_DEFAULT_OPTS+='--pointer "→" '
FZF_DEFAULT_OPTS+='--marker "✔" '
FZF_DEFAULT_OPTS+='--color '
FZF_DEFAULT_OPTS+='fg:-1,bg:-1,'
FZF_DEFAULT_OPTS+='hl:1,hl+:1,'
FZF_DEFAULT_OPTS+='fg+:6,bg+:-1'
export FZF_DEFAULT_OPTS


## Prompt --------------------------------------------------
## Git info via vcs_info:
##  - current branch (and action, e.g. rebase/merge)
##  - staged changes exist
##  - unstaged changes exist
autoload -Uz vcs_info add-zsh-hook
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' formats ' ⎇ %b%c%u'
zstyle ':vcs_info:git:*' actionformats ' ⎇ %b|%a%c%u'

# Symbols for staged/unstaged changes
zstyle ':vcs_info:git:*' stagedstr ' %F{green}●%f'
zstyle ':vcs_info:git:*' unstagedstr ' %F{red}●%f'

# Run vcs_info before every prompt
add-zsh-hook precmd vcs_info

setopt prompt_subst
PROMPT='%F{6}▶%f %F{6}%1/%f${vcs_info_msg_0_} » '
