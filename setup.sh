#!/usr/bin/env bash
set -Eeuo pipefail

REPO_BASE="git@github.com:cipherodio/"

DMENU_REPO="${REPO_BASE}archdmenu.git"
STARTPAGE_REPO="${REPO_BASE}startpage.git"
NOTES_REPO="${REPO_BASE}mdnotes.git"

HOME_DIR="$HOME"
SRC_DIR="$HOME_DIR/.local/src"

# Helpers
msg() { echo -e "\e[1;92m==>\e[0m $1"; }
die() {
    echo -e "\e[1;31merror:\e[0m $1" >&2
    exit 1
}
clone_if_missing() {
    local repo="$1" dest="$2"
    if [[ -d "$dest/.git" ]]; then
        msg "Already exists: $dest"
    else
        git clone "$repo" "$dest"
    fi
}

# Preconditions
command -v git >/dev/null || die "git not installed"
command -v make >/dev/null || die "make not installed"
command -v sudo >/dev/null || die "sudo not installed"

mkdir -p "$SRC_DIR"

# SSH sanity check
msg "Checking GitHub SSH authentication"
ssh -T git@github.com 2>&1 |
    grep -Eq "successfully authenticated|Hi .*!" ||
    die "SSH key not authenticated with GitHub"

# Source builds
msg "Building dmenu"
clone_if_missing "$DMENU_REPO" "$SRC_DIR/archdmenu"
(
    cd "$SRC_DIR/archdmenu"
    make clean >/dev/null 2>&1 || true
    make
    sudo make install
)

msg "Cloning startpage"
clone_if_missing "$STARTPAGE_REPO" "$SRC_DIR/startpage"

# Notes
msg "Cloning notes"
clone_if_missing "$NOTES_REPO" "$SRC_DIR/mdnotes"

# Done
msg "setup.sh complete"

# Last Modified: Fri, 09 Jan 2026 09:23:21 PM
