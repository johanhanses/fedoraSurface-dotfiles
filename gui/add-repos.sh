#!/usr/bin/env sh
# GUI apps from vendor DNF repos. Needs root: sudo ./gui/add-repos.sh
# Safe to re-run.
set -e

if [ "$(id -u)" -ne 0 ]; then
  echo "Run as root: sudo $0" >&2
  exit 1
fi

# --- 1Password ---------------------------------------------------------------
# The DNF repo has the `op` CLI for aarch64, but the desktop app only on x86_64.
# On aarch64 the app comes from 1Password's signed tarball into /opt/1Password
# (re-run this script to update it).
rpm --import https://downloads.1password.com/linux/keys/1password.asc
cat > /etc/yum.repos.d/1password.repo <<'REPO'
[1password]
name=1Password Stable Channel
baseurl=https://downloads.1password.com/linux/rpm/stable/$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://downloads.1password.com/linux/keys/1password.asc
REPO
dnf install -y 1password-cli

if [ "$(uname -m)" = "x86_64" ]; then
  dnf install -y 1password
else
  TMP="$(mktemp -d)"
  trap 'rm -rf "$TMP"' EXIT
  url="https://downloads.1password.com/linux/tar/stable/$(uname -m)/1password-latest.tar.gz"
  echo "==> Downloading 1Password app (tarball)"
  curl -fsSL "$url" -o "$TMP/1password.tar.gz"
  curl -fsSL "$url.sig" -o "$TMP/1password.tar.gz.sig"
  curl -fsSL https://downloads.1password.com/linux/keys/1password.asc -o "$TMP/key.asc"
  echo "==> Verifying signature"
  # gpgv: standalone verifier, no agent/keyboxd (plain gpg misbehaved as root)
  gpg --dearmor < "$TMP/key.asc" > "$TMP/key.gpg"
  gpgv --keyring "$TMP/key.gpg" "$TMP/1password.tar.gz.sig" "$TMP/1password.tar.gz"
  echo "==> Installing to /opt/1Password"
  tar -xzf "$TMP/1password.tar.gz" -C "$TMP"
  rm -rf /opt/1Password
  mv "$TMP"/1password-*/ /opt/1Password
  sh /opt/1Password/after-install.sh
  echo "==> 1Password app installed: /opt/1Password"
fi
