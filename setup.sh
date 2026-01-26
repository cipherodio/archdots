#!/usr/bin/env bash
# Author: cipherodio
# Description: Run after bootstrap.sh and copying ssh key to github
# via firefox `cat ~/.ssh/githubkey.pub | xclip -selection clipboard`
# User environment setup (post-login)
# Assumes:
#   - dotfiles are installed and sourced
#   - PATH, npm prefix, SSH config are active

set -Eeuo pipefail

# Safety
[[ $EUID -eq 0 ]] && {
    echo "error: do not run setup.sh as root" >&2
    exit 1
}

# Variables
HOME_DIR="$HOME"

REPO_BASE="git@github.com:cipherodio/"
STARTPAGE_REPO="${REPO_BASE}startpage.git"
NOTES_REPO="${REPO_BASE}mdnotes.git"

SRC_DIR="$HOME_DIR/.local/src"
DOTS_DIR="$HOME_DIR/.config/.dots"

FIREFOX_SRC="$HOME_DIR/.config/firefox/user.js"
FIREFOX_DIR="$HOME_DIR/.config/mozilla/firefox"
PROFILES_INI="$FIREFOX_DIR/profiles.ini"

CHROME_SRC="$HOME_DIR/.config/firefox/chrome/onedark"

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
    "$HOME_DIR/.local"/{downloads,notes,review,screenshot,torrent,projects} \
    "$HOME_DIR/.venv"

msg "Done creating user directories"

# GitHub SSH check
msg "Checking GitHub SSH access"

if git ls-remote "$STARTPAGE_REPO" >/dev/null 2>&1; then
    msg "GitHub SSH access OK"
else
    die "GitHub SSH access failed.
Ensure:
  - ssh-agent is running
  - your key is added (ssh-add)
  - the key is uploaded to GitHub"
fi

# Startpage
msg "Processing startpage"
clone_if_missing "$STARTPAGE_REPO" "$SRC_DIR/startpage"
msg "Done processing startpage"

# Notes
msg "Processing notes"
clone_if_missing "$NOTES_REPO" "$SRC_DIR/mdnotes"
msg "Done processing notes"

# NPM packages
msg "Installing NPM packages"
npm install -g markdown-toc
msg "Done installing NPM packages"

# Firefox user.js + chrome CSS
msg "Configuring Firefox user.js and chrome CSS"

if [[ ! -f "$FIREFOX_SRC" ]]; then
    msg "No Firefox user.js found, skipping Firefox config"
else
    [[ -f "$PROFILES_INI" ]] || die "Firefox profiles.ini not found"

    PROFILE_PATH="$(
        sed -n '/^\[Install/{n;/^Default=/s/^Default=//p;q}' "$PROFILES_INI"
    )"

    [[ -n "$PROFILE_PATH" ]] || die "Failed to detect Firefox profile path"

    PROFILE_DIR="$FIREFOX_DIR/$PROFILE_PATH"
    USERJS_DST="$PROFILE_DIR/user.js"
    CHROME_DST="$PROFILE_DIR/chrome"

    [[ -d "$PROFILE_DIR" ]] || die "Firefox profile directory not found"

    # User.js
    if [[ -f "$USERJS_DST" ]]; then
        cp "$USERJS_DST" "$USERJS_DST.bak"
        msg "Backed up existing user.js"
    fi

    cp "$FIREFOX_SRC" "$USERJS_DST"
    msg "Installed Firefox user.js"

    # Chrome CSS
    mkdir -p "$CHROME_DST"

    cp "$CHROME_SRC/userChrome.css" "$CHROME_DST/userChrome.css"
    cp "$CHROME_SRC/userContent.css" "$CHROME_DST/userContent.css"

    msg "Installed Firefox chrome CSS"
fi

# Change dotfiles remote (HTTPS → SSH)
msg "Fixing dotfiles git remote"

git --git-dir="$DOTS_DIR" --work-tree="$HOME_DIR" \
    remote set-url origin git@github.com:cipherodio/archdots.git

msg "Done fixing git remotes"

# Done
msg "setup.sh complete"

# Last Modified: Mon, 26 Jan 2026 05:51:15 PM
