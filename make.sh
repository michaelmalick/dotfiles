#!/bin/bash
set -euo pipefail

DIR="$HOME/.dotfiles"
BKP="$HOME/.dotfiles_bkp"

declare -a SOURCE_FILES=(
    "zshrc"
    "rgignore"
    "Rprofile"
    "tmux.conf"
)

declare -a DEST_PATHS=(
    "$HOME/.zshrc"
    "$HOME/.rgignore"
    "$HOME/.Rprofile"
    "$HOME/.config/tmux/tmux.conf"
)

mkdir -p "$BKP"

for i in "${!SOURCE_FILES[@]}"; do
    SOURCE="$DIR/${SOURCE_FILES[$i]}"
    DEST="${DEST_PATHS[$i]}"

    # if no file in .dotfiles, skip
    if [[ ! -f "$SOURCE" ]]; then
        echo "Source file $SOURCE does not exist, skipping..."
        continue
    fi

    mkdir -p "$(dirname "$DEST")"

    # backup files
    if [[ -e "$DEST" ]] || [[ -L "$DEST" ]]; then
        BACKUP_NAME="${SOURCE_FILES[$i]}_$(date +%Y%m%d_%H%M%S)"
        echo "Backing up $DEST to $BKP/$BACKUP_NAME"
        mv "$DEST" "$BKP/$BACKUP_NAME"
    fi

    echo "Linking $SOURCE -> $DEST"
    ln -sfn "$SOURCE" "$DEST"
done

echo "Dotfile setup complete!"
