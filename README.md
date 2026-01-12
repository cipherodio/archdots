# 🍚 Arch Linux Dotfiles

![archlinux_logo](.local/wallpapers/archlinux-logo.svg)

## 📔 Overview

Personal _dotfiles_ for [Archlinux](arch) and [Qtile](qtile).

| **Dependencies**  | **Description** |
| ----------------- | --------------- |
| Qtile             | Window manager  |
| Neovim            | Editor          |
| Alacritty         | Terminal        |
| Iosevka Nerd Font | System font     |

## 📸 Screenshots

![screenshot01](.local/wallpapers/screenshot001.png)

![screenshot02](.local/wallpapers/screenshot002.png)

## 🚀 Dotfiles Installation

I use **Git Bare** repository to manage my dotfiles and use a wrapper
script [dot](.local/bin/dot) after initial configuration below.

```sh
curl -fsSL https://raw.githubusercontent.com/cipherodio/archdots/main/bootstrap.sh | bash
reboot

cat ~/.ssh/githubkey.pub | xclip -selection clipboard
./setup.sh
```

[arch]: https://archlinux.org/
[qtile]: https://qtile.org/
