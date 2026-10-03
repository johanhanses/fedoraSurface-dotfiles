#!/usr/bin/env sh
# Per-user Nerd Fonts in ~/.local/share/fonts. No root needed; skips installed fonts.
set -e

NF_VERSION="v3.5.1"
FONTS="UbuntuMono"
FONT_DIR="$HOME/.local/share/fonts"

for font in $FONTS; do
  dest="$FONT_DIR/${font}NerdFont"
  if [ -d "$dest" ]; then
    echo "  $font Nerd Font already installed"
    continue
  fi
  echo "  installing $font Nerd Font $NF_VERSION"
  mkdir -p "$dest"
  curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/download/$NF_VERSION/$font.tar.xz" \
    | tar -xJ -C "$dest"
  fc-cache -f "$dest" >/dev/null
done
