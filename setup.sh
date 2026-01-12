#!/usr/bin/env bash
set -Eeuo pipefail

# setup.sh — user environment setup (post-login)
# Assumes:
#   - dotfiles are installed and sourced
#   - PATH, npm prefix, SSH config are active

# Safety
[[ $EUID -eq 0 ]] && {
    echo "error: do not run setup.sh as root" >&2
    exit 1
}

REPO_BASE="git@github.com:cipherodio/"
DMENU_REPO="${REPO_BASE}archdmenu.git"
STARTPAGE_REPO="${REPO_BASE}startpage.git"
NOTES_REPO="${REPO_BASE}mdnotes.git"

HOME_DIR="$HOME"
SRC_DIR="$HOME_DIR/.local/src"
DOTS_DIR="$HOME_DIR/.config/.dots"

# Helpers
msg() {
    printf '\033[1;92m==>\033[0m %s\n' "$1"
}

die() {
    printf '\033[1;31merror:\033[0m %s\n' "$1" >&2
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

# Preconditions
msg "Checking required commands"
command -v git >/dev/null || die "git not installed"
command -v make >/dev/null || die "make not installed"
command -v npm >/dev/null || die "npm not installed"
msg "All required commands available"

# User directories
msg "Creating user directories"

mkdir -p \
    "$SRC_DIR" \
    "$HOME_DIR/.local"/{downloads,notes,review,screenshot,torrent,podcast} \
    "$HOME_DIR/.venv"

msg "Done creating user directories"

# GitHub SSH check (REAL check, fail only if needed)
msg "Checking GitHub SSH access"

if git ls-remote "$DMENU_REPO" >/dev/null 2>&1; then
    msg "GitHub SSH access OK"
else
    die "GitHub SSH access failed.
Ensure:
  - ssh-agent is running
  - your key is added (ssh-add)
  - the key is uploaded to GitHub"
fi

# Build dmenu
msg "Building dmenu"

clone_if_missing "$DMENU_REPO" "$SRC_DIR/archdmenu"

(
    cd "$SRC_DIR/archdmenu"
    make clean >/dev/null 2>&1 || true
    make
    sudo make install
)

msg "Done building dmenu"

# Startpage
msg "Processing startpage"
clone_if_missing "$STARTPAGE_REPO" "$SRC_DIR/startpage"
msg "Done processing startpage"

# Notes
msg "Processing notes"
clone_if_missing "$NOTES_REPO" "$SRC_DIR/mdnotes"
msg "Done processing notes"

# NPM packages (env already active)
msg "Installing NPM packages"

npm install -g markdown-toc

msg "Done installing NPM packages"

# Change dotfiles remote (HTTPS → SSH)
msg "Fixing dotfiles git remote"

git --git-dir="$DOTS_DIR" --work-tree="$HOME_DIR" \
    remote set-url origin git@github.com:cipherodio/archdots.git

msg "Done fixing git remotes"

# Done
msg "setup.sh complete"

# Last Modified: Mon, 12 Jan 2026 11:05:18 AM
