#!/usr/bin/env sh
# GNOME Shell extensions from extensions.gnome.org (no root). Picks the build
# for the running GNOME version and marks them enabled. On Wayland, new
# extensions start at the next login.
set -e

EXTENSIONS="
window-gap@amirhosseinkarimi.github.io
"

SHELL_VERSION="$(gnome-extensions version | cut -d. -f1)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

for uuid in $EXTENSIONS; do
  if gnome-extensions list | grep -qx "$uuid"; then
    echo "  $uuid already installed"
    continue
  fi
  echo "==> $uuid (GNOME $SHELL_VERSION)"
  url="$(curl -fsSL "https://extensions.gnome.org/extension-info/?uuid=$uuid&shell_version=$SHELL_VERSION" \
    | grep -o '"download_url": *"[^"]*"' | cut -d'"' -f4)"
  curl -fsSL "https://extensions.gnome.org$url" -o "$TMP/ext.zip"
  gnome-extensions install --force "$TMP/ext.zip"
done

# Mark them enabled; on Wayland they start at the next login.
for uuid in $EXTENSIONS; do
  current="$(gsettings get org.gnome.shell enabled-extensions)"
  case "$current" in
    *"'$uuid'"*) ;;
    "@as []") gsettings set org.gnome.shell enabled-extensions "['$uuid']" ;;
    *) gsettings set org.gnome.shell enabled-extensions "${current%]}, '$uuid']" ;;
  esac
done
echo "  enabled: $(gsettings get org.gnome.shell enabled-extensions)"

# --- Window Gap settings (outer gaps around maximized/tiled windows) ---------
# Top margin is larger so the gap clears the GNOME top bar visually.
WG="$HOME/.local/share/gnome-shell/extensions/window-gap@amirhosseinkarimi.github.io/schemas"
if [ -d "$WG" ]; then
  wg() { gsettings --schemadir "$WG" set org.gnome.shell.extensions.window-gap "$@"; }
  wg uniform false
  wg margin-top 40
  wg margin-bottom 20
  wg margin-left 20
  wg margin-right 20
  echo "  window-gap: top 40, sides/bottom 20"
fi
