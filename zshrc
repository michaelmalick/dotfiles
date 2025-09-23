## Zsh config
##
## On MacOS, there are two primary startup files
##  - .zprofile: path variables (sourced before .zshrc)
##  - .zshrc:    interactive settings


## Basics
export EDITOR=nvim
export VISUAL=nvim
export HISTSIZE=5000
export SAVEHIST=5000
export HISTFILE=~/.zsh_history
autoload -Uz colors && colors
export CLICOLOR=1

## Aliases
alias gs='git status'
alias gl='git log --decorate --graph --date=short --oneline --all'
alias gv='nvim +GV +"autocmd BufWipeout <buffer> qall"'
alias gd='git difftool'


## Completion ----------------------------------------------
autoload -Uz compinit && compinit
setopt no_list_beep

# Case-insensitive completion (foo matches Foo)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Enable menu selection with Tab
zstyle ':completion:*' menu select

# Avoid completing duplicate entries
zstyle ':completion:*' ignore-duplicates true

# Nice formatting for completion lists
zstyle ':completion:*:messages' format '%F{green}%d%f'
zstyle ':completion:*:warnings' format '%F{red}No matches%f'


## Functions -----------------------------------------------
tmuxkill() {
    tmux ls | \
    awk '{print $1}' | \
    sed 's/://g' | \
    xargs -I{} tmux kill-session -t {}
}


## FZF -----------------------------------------------------
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
FZF_DEFAULT_OPTS+='fg+:6,bg+:-1,'
export FZF_DEFAULT_OPTS

## cd into directory
cdf() {
    cd $(find . -maxdepth 1 -type d -not -path . -print 2> /dev/null | fzf);
}

## open in nvim
nvimf() {
    find . -maxdepth 1 \( -type f -o -type l \) -print 2> /dev/null | fzf --multi --print0 | xargs -0 nvim;
}

## command history
cr() {
  local selected
  selected=$(fc -l 1 | fzf --tac | sed 's/ *[0-9]* *//') || return
  print -z -- "$selected"
}


## Prompt --------------------------------------------------
## Prompt git info:
##  - current git branch
##  - staged changes exist
##  - unstaged changes exist
##  - untracked files exist
##  - ahead/behind remote
git_prompt_info() {
  local line branch ahead behind staged unstaged untracked
  local gitdir=$(git rev-parse --git-dir 2>/dev/null) || return

  # Read branch + status in one go
  while IFS= read -r line; do
    case $line in
      "# branch.head "*)
        branch=${line##* } ;;
      "# branch.ab "*)
        ahead=${line#*+}; ahead=${ahead%% *}
        behind=${line#*-}; behind=${behind%% *} ;;
      1\ ?M*) staged=1 ;;    # staged
      1\ M*)  unstaged=1 ;;  # unstaged
      \?*)    untracked=1 ;; # untracked
    esac
  done < <(git status --porcelain=v2 --branch 2>/dev/null)

  [[ -z $branch ]] && return

  # Symbols
  local out=" ⎇ $branch"
  (( ahead ))     && out+=" %F{green}↑$ahead%f"
  (( behind ))    && out+=" %F{red}↓$behind%f"
  (( staged ))    && out+=" %F{green}●%f"
  (( unstaged ))  && out+=" %F{red}●%f"
  (( untracked )) && out+=" %F{red}○%f"

  print -n $out
}

setopt prompt_subst
PROMPT='%F{6}▶%f %F{6}%1/%f$(git_prompt_info) » '
