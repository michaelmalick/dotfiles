#!/bin/bash
set -euo pipefail

DIR="$HOME/.dotfiles"
BKP="$HOME/.dotfiles_bkp"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
STAMP="$(date +%Y%m%d_%H%M%S)"

# source file in $DIR | destination
FILES=(
    "zshenv|$HOME/.zshenv"
    "zshrc|$XDG_CONFIG_HOME/zsh/.zshrc"
    "gitconfig|$XDG_CONFIG_HOME/git/config"
    "gitignore|$XDG_CONFIG_HOME/git/ignore"
    "Rprofile|$XDG_CONFIG_HOME/R/Rprofile"
    "tmux.conf|$XDG_CONFIG_HOME/tmux/tmux.conf"
    "air.toml|$XDG_CONFIG_HOME/air/air.toml"
    "vimrc|$XDG_CONFIG_HOME/vim/vimrc"
    "ghosttyconfig|$XDG_CONFIG_HOME/ghostty/config"
)

for entry in "${FILES[@]}"; do
    name="${entry%%|*}"
    src="$DIR/$name"
    dest="${entry#*|}"

    if [[ ! -f "$src" ]]; then
        echo "Skipping $name (not in $DIR)"
        continue
    fi

    # Already linked to the right place
    if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
        echo "Linked:    $dest"
        continue
    fi

    mkdir -p "$(dirname "$dest")"

    # Anything else in the way gets backed up
    if [[ -e "$dest" || -L "$dest" ]]; then
        mkdir -p "$BKP/$STAMP"
        echo "Backing up $dest -> $BKP/$STAMP/$name"
        mv "$dest" "$BKP/$STAMP/$name"
    fi

    echo "Linking:   $dest -> $src"
    ln -s "$src" "$dest"
done


# Neovim config (separate repo)
NVIM_REPO="https://github.com/michaelmalick/nvim-config.git"
NVIM_DIR="$XDG_CONFIG_HOME/nvim"

if [[ -d "$NVIM_DIR/.git" ]]; then
    echo "Exists:    $NVIM_DIR (git repo, not touched)"
else
    if [[ -e "$NVIM_DIR" || -L "$NVIM_DIR" ]]; then
        mkdir -p "$BKP/$STAMP"
        echo "Backing up $NVIM_DIR -> $BKP/$STAMP/nvim"
        mv "$NVIM_DIR" "$BKP/$STAMP/nvim"
    fi
    echo "Cloning:   $NVIM_REPO -> $NVIM_DIR"
    git clone "$NVIM_REPO" "$NVIM_DIR"
fi


# Machine-specific git identity (not tracked in dotfiles)
GIT_LOCAL="$XDG_CONFIG_HOME/git/config.local"

if [[ -f "$GIT_LOCAL" ]]; then
    echo "Exists:    $GIT_LOCAL"
else
    email="${GIT_EMAIL:-}"
    if [[ -z "$email" && -t 0 ]]; then
        read -rp "Git email for this machine: " email
    fi

    if [[ -n "$email" ]]; then
        mkdir -p "$(dirname "$GIT_LOCAL")"
        git config --file "$GIT_LOCAL" user.email "$email"
        echo "Created:   $GIT_LOCAL"
    else
        echo "Skipping $GIT_LOCAL (no email; set GIT_EMAIL or run interactively)"
    fi
fi

echo "Dotfile setup complete!"


