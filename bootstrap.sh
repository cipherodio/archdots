#!/usr/bin/env bash
# Author: cipherodio
# Description: Run on fresh installed Arch Linux

set -Eeuo pipefail

REPO_BASE="https://github.com/cipherodio"
DOTS_REPO="$REPO_BASE/archdots.git"

HOME_DIR="$HOME"
DOTS_DIR="$HOME_DIR/.config/.dots"

# Helpers
msg() {
    printf '\033[1;92m==>\033[0m %s\n' "$1"
}

die() {
    printf '\033[1;31merror:\033[0m %s\n' "$1" >&2
    exit 1
}

need() {
    command -v "$1" >/dev/null 2>&1 || die "missing dependency: $1"
}

# Preconditions
need sudo
need git

sudo -v
msg "Starting Arch one-shot bootstrap"
msg "Done checking prerequisites"

# System packages
msg "Installing ${#PKGS[@]} system packages"

PKGS=(
    # X / Display
    xcape xclip xdg-utils xdo xdotool
    xorg-xdpyinfo xorg-xev xorg-xinit xorg-xinput xorg-xprop
    xorg-xset xorg-xsetroot xorg-xwininfo xterm
    # Drivers
    lib32-vulkan-radeon mesa-utils vulkan-tools
    # Audio
    pipewire pipewire-alsa pipewire-pulse pulsemixer
    # Fonts
    libertinus-font noto-fonts noto-fonts-emoji
    ttc-iosevka ttc-iosevka-aile ttf-iosevka-nerd
    ttf-dejavu ttf-liberation
    # System
    acpi dunst libnotify npm picom qtile unclutter
    # System tools
    btop brightnessctl dosfstools evtest exfatprogs
    htop nvtop ntfs-3g pacutils
    # Utilities
    bc fd fzf highlight man-db maim moreutils
    pass psutils ripgrep tmux tree unrar unzip wget zip
    # Media
    feh ffmpeg ffmpegthumbnailer imagemagick mediainfo
    mpc mpd mpv ncmpcpp nsxiv yt-dlp
    # Programs
    alacritty audacity blender emacs firefox
    firefox-dark-reader firefox-extension-passff
    firefox-tridactyl firefox-ublock-origin
    gimp poppler spotify-launcher
    tesseract tesseract-data-eng tesseract-data-osd
    zathura zathura-pdf-mupdf
    # Cli
    lf newsboat transmission-cli
    # Python
    python-dbus-next python-iwlib python-mpd2
    python-pip python-psutil python-setproctitle
    # Dev
    bash-language-server lua-language-server marksman prettier
    python-debugpy python-lsp-server ruff shfmt shellcheck stylua
    tree-sitter-cli vscode-json-languageserver yaml-language-server
)
sudo pacman -Syu --needed --noconfirm "${PKGS[@]}"

msg "Done installing system packages"

# Verify pip
msg "Verifying pip"
command -v pip >/dev/null || die "pip not installed"
msg "Done verifying pip"

# Dotfiles (bare repo)
msg "Installing dotfiles"

if [[ ! -d "$DOTS_DIR" ]]; then
    git clone --bare "$DOTS_REPO" "$DOTS_DIR"
fi

git --git-dir="$DOTS_DIR" --work-tree="$HOME_DIR" checkout -f
msg "Done installing dotfiles"

# Cleanup legacy files
msg "Removing unused legacy shell configs"
rm -f "$HOME_DIR"/.{bash_logout,bash_profile,bashrc,zshrc}
rm -rf "$HOME_DIR/.nimble"
msg "Done cleaning legacy files"

# User services
msg "Enabling user services"
systemctl --user enable --now pipewire-pulse || true
msg "Done enabling user services"

# Python user packages
msg "Installing Python user packages"
pip install --user --upgrade pulsectl-asyncio
msg "Done installing Python user packages"

# SSH key
msg "Ensuring SSH key exists"

if [[ ! -f "$HOME_DIR/.ssh/githubkey" ]]; then
    mkdir -p "$HOME_DIR/.ssh"
    ssh-keygen -t ed25519 \
        -f "$HOME_DIR/.ssh/githubkey" \
        -C "cipherodio@gmail.com" \
        -N ""
fi

msg "Done ensuring SSH key"

# Done
msg "Bootstrap complete"
msg "Reboot recommended"

# Last Modified: Sat, 31 Jan 2026 06:53:45 AM
