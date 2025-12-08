#!/bin/bash

me="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
srcdir="$HOME/.local/src"
dmenudir="$HOME/.local/src/archdmenu"
startdir="$HOME/.local/src/startpage"
orgfile="$HOME/.config/emacs/cipherodio.org"
name="$USER"

menu() {
    echo -e "\e[1;4;35mUsage:\e[0m \e[1;37m" "$me" "[OPTION]\e[0m"
    echo " "
    echo -e "\e[1;92maurhelper:\e[0m ............ \e[37myay aur installation.\e[0m"
    echo -e "\e[1;92marchpkg:\e[0m .............. \e[37mARCH packages installation.\e[0m"
    echo -e "\e[1;92maurpkg:\e[0m ............... \e[37mARCH aur packages installation.\e[0m"
    echo -e "\e[1;92mdotfiles:\e[0m ............. \e[37mclone my personal dotfiles.\e[0m"
    echo -e "\e[1;92musersrv:\e[0m .............. \e[37menable user service.\e[0m"
    echo -e "\e[1;92mpippkg:\e[0m ............... \e[37menable user service.\e[0m"
    echo -e "\e[1;92mclean:\e[0m ................ \e[37mremove unwanted files and directory.\e[0m"
    echo -e "\e[1;92mdmenu:\e[0m ................ \e[37mdmenu personal build.\e[0m"
    echo -e "\e[1;92mstartpage:\e[0m ............ \e[37mstartpage for qutebrowser.\e[0m"
    echo -e "\e[1;92mtmuxplug:\e[0m ............. \e[37mclone tmux-resurrect.\e[0m"
    echo -e "\e[1;92morgtangle:\e[0m ............ \e[37mtangle org configuration.\e[0m"
    echo -e "\e[1;92mgenkey:\e[0m ............... \e[37mgenerate ssh-key.\e[0m"
    echo -e "\e[1;92mremoteurl:\e[0m ............ \e[37mchange src remote urls.\e[0m"
    echo -e "\e[1;92mnotes:\e[0m ................ \e[37mclone markdown notes.\e[0m"
}

aurhelper() {
    cd /tmp/ || exit
    curl -LO https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz
    tar xvzf yay.tar.gz
    cd yay || exit
    makepkg -sci
}

archpkg() {
    pkgs=(
        # xorg
        xorg-xdpyinfo xorg-xev xorg-xinit xorg-xinput xorg-xprop
        xcape xwallpaper xorg-xsetroot xorg-xwininfo xclip xterm
        xdo xdotool
        # amd
        lib32-vulkan-radeon mesa-utils vulkan-tools
        # audio
        pipewire pipewire-alsa pipewire-pulse pulsemixer
        # fonts
        ttf-dejavu ttf-liberation libertinus-font noto-fonts
        noto-fonts-emoji ttc-iosevka ttc-iosevka-aile ttf-iosevka-nerd
        # utilities
        evtest exfat-utils brightnessctl dosfstools bc btop htop nvtop
        maim ffmpeg ffmpegthumbnailer highlight imagemagick man-db
        gnome-keyring libnotify mediainfo moreutils ntfs-3g poppler
        picom psutils tmux ripgrep unrar unzip yt-dlp zip wget tree
        tesseract tesseract-data-eng tesseract-data-osd fd
        unclutter xdg-utils pacutils acpi npm
        # python
        python-dbus-next python-iwlib python-mpd2 python-pip python-psutil
        # programs
        firefox firefox-dark-reader firefox-tridactyl firefox-ublock-origin
        emacs alacritty lf dunst mpc mpd mpv ncmpcpp nsxiv newsboat gimp
        qtile spotify-launcher transmission-cli zathura zathura-pdf-mupdf
    )
    # install all listed pkgs
    # sudo pacman --needed --noconfirm -Syu "${pkgs[@]}"
    yay --needed --noconfirm -Syu "${pkgs[@]}"
}

aurpkg() {
    aurpkgs=(
        tremc-git
        # gtk-theme-arc-gruvbox-git
        firefox-tridactyl-native
        # firefox-extension-enhancer-for-youtube-bin
        # python-pulsectl-asyncio
    )
    # install all aur packages
    yay --needed --noconfirm --answerclean None --answerdiff None --removemake -S "${aurpkgs[@]}"
}

dotfiles() {
    cd ~ || exit
    git clone --bare https://github.com/cipherodio/archdots.git "$HOME"/.config/.dots
    git --git-dir="$HOME"/.config/.dots/ --work-tree="$HOME" checkout
    echo -e "\e[1;31mdone!\e[0m"
}

usersrv() {
    systemctl --user enable pipewire-pulse
    echo -e "\e[1;31mdone!\e[0m"
}

pippkg() {
    pip install --user pulsectl-asyncio
}

clean() {
    rm -rf /home/"$name"/.bash_logout
    rm -rf /home/"$name"/.bash_profile
    rm -rf /home/"$name"/.bashrc
    rm -rf /home/"$name"/.zshrc
    rm -rf /home/"$name"/.nimble
    mkdir -p /home/"$name"/.venv
    mkdir -p /home/"$name"/.local/downloads
    mkdir -p /home/"$name"/.local/notes
    mkdir -p /home/"$name"/.local/review
    mkdir -p /home/"$name"/.local/screenshot
    mkdir -p /home/"$name"/.local/src
    mkdir -p /home/"$name"/.local/torrent
    echo -e "\e[1;31mdone!\e[0m"
}

dmenu() {
    cd "$srcdir" || exit
    git clone https://github.com/cipherodio/archdmenu.git
    cd "$dmenudir" || exit
    make && sudo make install
}

startpage() {
    cd "$srcdir" || exit
    git clone https://github.com/cipherodio/startpage.git
}

tmuxplug() {
    git clone https://github.com/tmux-plugins/tmux-resurrect ~/.config/tmux/plugins/tmux-resurrect
}

orgtangle() {
    # emacs --batch -l org --eval "(org-babel-tangle-file $orgfile)"
    emacs --batch -l org "$orgfile" -f org-babel-tangle >/dev/null 2>&1
}

# Below scripts, run them after first reboot

genkey() {
    yes "y" | ssh-keygen -t ed25519 -C "cipherodio@gmail.com" -f ~/.ssh/githubkey -N "" -q
    echo -e "\e[1;31mdone!\e[0m"
}

remoteurl() {
    cd "$startdir" || exit
    git remote set-url origin git@github.com:cipherodio/startpage.git
    cd ~/ || exit
    git --git-dir="$HOME"/.config/.dots --work-tree="$HOME" remote set-url origin git@github.com:cipherodio/archdots.git
    echo -e "\e[1;31mdone!\e[0m"
}

notes() {
    cd "$srcdir" || exit
    git clone git@github.com:cipherodio/mdnotes.git
}

if [ -n "$1" ]; then
    $1
else
    menu
fi

# Last Modified: Mon, 08 Dec 2025 09:45:02 PM
