#!/usr/bin/env sh
# System packages for the Surface (Fedora 44, aarch64). Needs root:
#   sudo ./setup-packages.sh
# Safe to re-run: dnf, copr enable and repo drops are no-ops once done.
set -e

if [ "$(id -u)" -ne 0 ]; then
  echo "Run as root: sudo $0" >&2
  exit 1
fi

# --- CLI basics (Fedora repos) -----------------------------------------------
dnf install -y gh zsh zsh-autosuggestions zsh-syntax-highlighting fzf zoxide

# --- Ghostty (COPR scottames/ghostty; has fedora-44-aarch64 builds) ----------
dnf copr enable -y scottames/ghostty
dnf install -y ghostty

# --- Wispr Flow (unofficial community port, signed repo, arm64 builds) -------
curl -fsSL https://pkg.wispr-flow-linux.dev/rpm/wispr-flow.repo \
  -o /etc/yum.repos.d/wispr-flow.repo
dnf install -y wispr-flow

echo "Done. Make zsh the login shell (as your user): chsh -s /usr/bin/zsh"
