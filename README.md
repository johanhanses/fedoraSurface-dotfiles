# fedoraSurface-dotfiles

Dotfiles for a Microsoft Surface Laptop 7 (Snapdragon, **aarch64**) running
Fedora 44 with GNOME on Wayland.

Configs live in this repo and `install.sh` symlinks them into place.

## Setup

```sh
git clone git@github.com:johanhanses/fedoraSurface-dotfiles.git ~/Repos/github.com/johanhanses/fedoraSurface-dotfiles
cd ~/Repos/github.com/johanhanses/fedoraSurface-dotfiles
sudo ./setup-packages.sh   # dnf packages + repos
./install.sh               # symlinks + fonts (no root)
chsh -s /usr/bin/zsh
```

## What's here

| Path | Goes to | Notes |
|---|---|---|
| `zsh/.zshrc` | `~/.zshrc` | Minimal: history, completion, git-branch prompt, fzf, zoxide, dnf plugins |
| `ghostty/config` | `~/.config/ghostty/config` | UbuntuMono Nerd Font; theme follows GNOME light/dark |
| `ghostty/themes/` | `~/.config/ghostty/themes` | **Dirigent Light / Dark**: custom themes from Dirigent's "score" palette (paper & ink, signal-orange cursor) |
| `git/.gitconfig` | `~/.gitconfig` | Identity + default branch only, for now |
| `fonts/install-fonts.sh` | `~/.local/share/fonts` | Nerd Fonts, per user |
| `setup-packages.sh` | system | gh, zsh plugins, fzf, zoxide, Ghostty (COPR), Wispr Flow |

## ARM notes

- Ghostty: not in Fedora's own repos; the `scottames/ghostty` COPR builds for aarch64.
- Wispr Flow: no official Linux app. The community port
  ([wispr-flow-linux](https://github.com/wispr-flow-linux/wispr-flow-linux))
  ships arm64 RPMs. `wispr-flow --doctor` passes out of the box; no udev rule
  or paste remap was needed.
- Check the architecture before adding any upstream binary download.
