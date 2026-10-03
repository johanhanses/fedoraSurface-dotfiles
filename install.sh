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

# --- tmux --------------------------------------------------------------------
# Only the file is linked, so TPM plugins land in ~/.config/tmux/plugins
# (outside the repo). Then `prefix + I` inside tmux installs the plugins.
link tmux/tmux.conf "$HOME/.config/tmux/tmux.conf"
if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
  git clone -q https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
  echo "  cloned tpm"
fi

# --- sesh --------------------------------------------------------------------
link sesh/sesh.toml "$HOME/.config/sesh/sesh.toml"
# Work sessions: private overlay from dotfiles-private (skipped if not cloned)
PRIVATE="$HOME/Repos/github.com/johanhanses/dotfiles-private"
if [ -f "$PRIVATE/config/sesh/local.toml" ]; then
  ln -sfn "$PRIVATE/config/sesh/local.toml" "$HOME/.config/sesh/local.toml"
  echo "  $HOME/.config/sesh/local.toml -> $PRIVATE/config/sesh/local.toml"
else
  echo "  (skip sesh local.toml: dotfiles-private not cloned)"
fi

# --- Git ---------------------------------------------------------------------
link git/.gitconfig "$HOME/.gitconfig"

# --- Fonts -------------------------------------------------------------------
sh "$DOTFILES/fonts/install-fonts.sh"

echo "Done."
