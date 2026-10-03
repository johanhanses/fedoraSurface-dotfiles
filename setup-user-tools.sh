#!/usr/bin/env sh
# Upstream binaries not packaged for Fedora, installed per user into
# ~/.local/bin (no root). Re-running fetches the latest release again.
set -e

BINDIR="$HOME/.local/bin"
mkdir -p "$BINDIR"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

case "$(uname -m)" in
  aarch64) ARCH=arm64 ;;
  x86_64)  ARCH=x86_64 ;;
  *) echo "Unsupported arch: $(uname -m)" >&2; exit 1 ;;
esac

# gh_asset <owner/repo> <exact-asset-name>: download URL from the latest release
gh_asset() {
  curl -fsSL "https://api.github.com/repos/$1/releases/latest" \
    | grep -o "https://[^\"]*/$2\"" | tr -d '"' | head -n1
}

echo "==> sesh (joshmedeski/sesh, $ARCH)"
curl -fsSL "$(gh_asset joshmedeski/sesh "sesh_Linux_$ARCH.tar.gz")" -o "$TMP/sesh.tgz"
tar -xzf "$TMP/sesh.tgz" -C "$TMP" sesh
install -m 0755 "$TMP/sesh" "$BINDIR/sesh"
"$BINDIR/sesh" --version

echo "Done. Installed to $BINDIR"
