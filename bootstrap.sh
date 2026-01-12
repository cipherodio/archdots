#!/usr/bin/env bash
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
need curl

sudo -v
msg "Starting Arch one-shot bootstrap"
msg "Done checking prerequisites"

# System packages
msg "Installing system packages"

sudo pacman -Syu --needed --noconfirm \
    xorg-xdpyinfo xorg-xev xorg-xinit xorg-xinput xorg-xprop \
    xcape xwallpaper xorg-xsetroot xorg-xwininfo xclip xterm \
    xdo xdotool \
    lib32-vulkan-radeon mesa-utils vulkan-tools \
    pipewire pipewire-alsa pipewire-pulse pulsemixer \
    ttf-dejavu ttf-liberation libertinus-font noto-fonts \
    noto-fonts-emoji ttc-iosevka ttc-iosevka-aile ttf-iosevka-nerd \
    evtest exfatprogs brightnessctl dosfstools bc btop htop nvtop \
    maim ffmpeg ffmpegthumbnailer highlight imagemagick man-db \
    gnome-keyring libnotify mediainfo moreutils ntfs-3g poppler \
    picom psutils tmux ripgrep unrar unzip yt-dlp zip wget tree \
    tesseract tesseract-data-eng tesseract-data-osd fd \
    unclutter xdg-utils pacutils acpi npm fzf blender audacity \
    python-dbus-next python-iwlib python-mpd2 python-pip python-psutil \
    firefox firefox-dark-reader firefox-tridactyl firefox-ublock-origin \
    emacs alacritty lf dunst mpc mpd mpv ncmpcpp nsxiv newsboat gimp \
    qtile spotify-launcher transmission-cli zathura zathura-pdf-mupdf \
    lua-language-server marksman bash-language-server stylua shfmt \
    shellcheck prettier python-lsp-server ruff yaml-language-server \
    vscode-json-languageserver python-debugpy

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

# Last Modified: Mon, 12 Jan 2026 09:29:13 AM
