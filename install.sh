#!/usr/bin/env sh
# Symlink configs from this repo into place. No root needed; safe to re-run.
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

link() {
  # link <path-in-repo> <dest>: back up a real file once, then symlink
  src="$DOTFILES/$1"
  dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "$dest.bak"
    echo "  backed up $dest -> $dest.bak"
  fi
  ln -sfn "$src" "$dest"
  echo "  $dest -> $src"
}

echo "Linking dotfiles from $DOTFILES"

# --- zsh ---------------------------------------------------------------------
link zsh/.zshrc "$HOME/.zshrc"

# --- Ghostty -----------------------------------------------------------------
link ghostty/config "$HOME/.config/ghostty/config"
link ghostty/themes "$HOME/.config/ghostty/themes"

# --- Git ---------------------------------------------------------------------
link git/.gitconfig "$HOME/.gitconfig"

# --- Fonts -------------------------------------------------------------------
sh "$DOTFILES/fonts/install-fonts.sh"

echo "Done."
