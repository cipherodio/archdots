#!/usr/bin/env bash
set -Eeuo pipefail

REPO_BASE="git@github.com:cipherodio/"
DMENU_REPO="${REPO_BASE}archdmenu.git"
STARTPAGE_REPO="${REPO_BASE}startpage.git"
NOTES_REPO="${REPO_BASE}mdnotes.git"

HOME_DIR="$HOME"
SRC_DIR="$HOME_DIR/.local/src"
DOTS_DIR="$HOME_DIR/.config/.dots"

# --------------------------------------------------
# Helpers
# --------------------------------------------------
msg() {
    echo "==> $1"
}

die() {
    echo "error: $1" >&2
    exit 1
}

clone_if_missing() {
    local repo="$1"
    local dest="$2"

    msg "Processing $dest"

    if [[ -d "$dest/.git" ]]; then
        git -C "$dest" pull --ff-only
        msg "Updated $dest"
    else
        git clone "$repo" "$dest"
        msg "Cloned $dest"
    fi
}

# --------------------------------------------------
# Preconditions
# --------------------------------------------------
msg "Checking required commands"
command -v git  >/dev/null || die "git not installed"
command -v make >/dev/null || die "make not installed"
command -v sudo >/dev/null || die "sudo not installed"
msg "All required commands available"

# --------------------------------------------------
# User directories (workspace)
# --------------------------------------------------
msg "Creating user directories"

mkdir -p \
    "$SRC_DIR" \
    "$HOME_DIR/.local"/{downloads,notes,review,screenshot,torrent} \
    "$HOME_DIR/.venv"

msg "Done creating user directories"

# --------------------------------------------------
# SSH sanity check
# --------------------------------------------------
msg "Checking GitHub SSH authentication"
ssh -T git@github.com 2>&1 | grep -qi "github" || die "SSH auth failed"
msg "GitHub SSH authentication OK"

# --------------------------------------------------
# Source builds
# --------------------------------------------------
msg "Building dmenu"
clone_if_missing "$DMENU_REPO" "$SRC_DIR/archdmenu"
(
    cd "$SRC_DIR/archdmenu"
    make clean >/dev/null 2>&1 || true
    make
    sudo make install
)
msg "Done building dmenu"

# --------------------------------------------------
# Startpage
# --------------------------------------------------
msg "Processing startpage"
clone_if_missing "$STARTPAGE_REPO" "$SRC_DIR/startpage"
msg "Done processing startpage"

# --------------------------------------------------
# Notes
# --------------------------------------------------
msg "Processing notes"
clone_if_missing "$NOTES_REPO" "$SRC_DIR/mdnotes"
msg "Done processing notes"

# --------------------------------------------------
# Fix git remotes
# --------------------------------------------------
msg "Fixing git remotes"
cd "$HOME_DIR" || exit
git --git-dir="$DOTS_DIR" --work-tree="$HOME_DIR" \
    remote set-url origin git@github.com:cipherodio/archdots.git
msg "Done fixing git remotes"

# --------------------------------------------------
# Done
# --------------------------------------------------
msg "setup.sh complete"

# Last Modified: Sat, 10 Jan 2026 06:56:32 PM
