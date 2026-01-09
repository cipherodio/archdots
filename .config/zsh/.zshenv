# Environmental variables
typeset -U PATH
# Path to scripts
export PATH="$HOME/.local/bin:$PATH"

unsetopt PROMPT_SP 2>/dev/null

LS_COLORS="di=34:ln=31:pi=42:ex=32:tw=0:ow=0:st=0:*.zip=35:*.gz=35\
:*.tar=35:*.xz=35:*.mp3=36:*.flac=36:*.mkv=36:*.mp4=36:*.mov=36\
:*.webm=36:*.jpg=33:*.png=33:*.jpeg=33"
export LS_COLORS

# Default programs:
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="alacritty"
export TERM="xterm-256color"
export BROWSER="firefox"
export READER="zathura"
export FILE="lf"
export WM="qtile"

# XDG Base Directory
export XDG_LOCAL_HOME="$HOME/.local"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

# Relocate variables
#export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/pass"
export INPUTRC="$XDG_CONFIG_HOME/shell/inputrc"
export MBSYNCRC="$HOME/.config/mbsync/mbsyncrc"
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuchrc"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export ZPLUG="$ZDOTDIR/zplug"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
export GOBIN="$XDG_LOCAL_HOME/bin"
export GOPATH="$XDG_DATA_HOME/go"
export GOMODCACHE="$XDG_CACHE_HOME/go/mod"
export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/rgrc"
export NIMBLE_DIR="$HOME/.config/nimble"

# Npm path
export PATH="$HOME/.local/share/node_modules/bin:$PATH"
export NPM_CONFIG_PREFIX="$HOME/.local/share/node_modules"
export NPM_CONFIG_USERCONFIG="$HOME/.config/npm/npmrc"
export NPM_CONFIG_CACHE="$HOME/.cache/npm"
export NPM_CONFIG_TMP="$XDG_RUNTIME_DIR/npm"

# Misc
export HISTSIZE=1000
export SAVEHIST=1000
export HISTFILE="$ZDOTDIR/.history"
export LESSHISTFILE="-"
export SUDO_ASKPASS="$HOME/.local/bin/dmenu-pass"
export SUDO_PROMPT=$'\e[1;31m'[$'\e[0m'sudo$'\e[1;31m']$'\e[0m'' password for '$'\e[1;31m''%p'$'\e[0m'': '
export SPROMPT="%F{blue}[%fzsh%F{blue}]%f correct %F{red}%R%f to %F{blue}%r%f [nyae]: "

export FZF_DEFAULT_OPTS="
--color=bg:#1d2021
--color=bg+:#3c3836
--color=fg:#ebdbb2
--color=fg+:#fbf1c7
--color=hl:#fabd2f
--color=hl+:#fabd2f
--color=header:#83a598
--color=info:#d3869b
--color=pointer:#fe8019
--color=marker:#fe8019
--color=spinner:#fe8019
--color=prompt:#b8bb26
--color=border:#504945
--color=query:#ebdbb2
--gutter ' '
--exact
--no-separator
--no-bold
--reverse
--height 40%
"

# Less
export GROFF_NO_SGR=1
export PAGER="less"
export LESS="-R"
export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"

export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;32m'
export LESS_TERMCAP_ue=$'\e[0m'

# Fix for java applications in dwm
export _JAVA_AWT_WM_NONREPARENTING=1

# NOTE: Set Qt to use GTK theme (This breaks kdenlive, shotcut)

# export QT_QPA_PLATFORMTHEME="gtk2"
# export QT_QPA_PLATFORMTHEME="qt6ct"

# NOTE: Disable scaling for now

# export QT_SCALE_FACTOR=1.3
# export GDK_DPI_SCALE=1.3

# Enable DRM Content in qutebrowser
# export QTWEBENGINE_CHROMIUM_FLAGS="--widevine-path=/usr/lib/chromium/libwidevinecdm.so"
# Mozilla zoom in and out
export MOZ_USE_XINPUT2=1

# Shortcuts
[ ! -f "$XDG_CONFIG_HOME"/shell/shrc ] && setsid -f shortcuts >/dev/null 2>&1

# Last Modified: Sat, 10 Jan 2026 12:31:29 AM
