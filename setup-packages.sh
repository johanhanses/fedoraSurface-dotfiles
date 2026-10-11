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
dnf install -y gh zsh zsh-autosuggestions zsh-syntax-highlighting fzf zoxide eza \
  tmux wl-clipboard neovim ripgrep btop
# tmux + wl-clipboard: tmux.conf copies to the Wayland clipboard via wl-copy.
# neovim: $EDITOR in .zshrc. ripgrep: fzf/nvim searches. btop: monitor.

# --- Mail / calendar ---------------------------------------------------------
# Thunderbird + the paid "Owl for Office365" add-on (installed from inside
# Thunderbird) for work M365 mail/calendar/contacts; Gmail and iCloud CalDAV
# in the same profile. Fallback if Owl breaks: evolution + evolution-ews
# (its Microsoft 365 account type uses Graph for calendar too).
dnf install -y thunderbird

# --- Ghostty (COPR scottames/ghostty; has fedora-44-aarch64 builds) ----------
dnf copr enable -y scottames/ghostty
dnf install -y ghostty

# --- Wispr Flow (unofficial community port, signed repo, arm64 builds) -------
curl -fsSL https://pkg.wispr-flow-linux.dev/rpm/wispr-flow.repo \
  -o /etc/yum.repos.d/wispr-flow.repo
dnf install -y wispr-flow

echo "Done. Make zsh the login shell (as your user): chsh -s /usr/bin/zsh"
