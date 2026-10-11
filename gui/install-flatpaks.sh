#!/usr/bin/env sh
# GUI apps as per-user Flatpaks (no root). Safe to re-run.
# Fedora's system Flathub is filtered, so add the full Flathub per user.
set -e

flatpak remote-add --user --if-not-exists flathub \
  https://flathub.org/repo/flathub.flatpakrepo

APPS="
com.mattermost.Desktop
com.github.IsmaelMartinez.teams_for_linux
md.obsidian.Obsidian
com.mattjakeman.ExtensionManager
"

for app in $APPS; do
  echo "==> $app"
  flatpak install --user -y --noninteractive flathub "$app"
done
