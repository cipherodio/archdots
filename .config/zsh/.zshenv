# Environmental variables
typeset -U PATH
# Path to scripts
export PATH="$HOME/.local/bin:$PATH"

unsetopt PROMPT_SP 2>/dev/null

# Default programs:
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="alacritty"
export TERM="xterm-256color"
export BROWSER="firefox"
export READER="zathura"
export FILE="lf"
export WM="Qtile"
export NVD_DIR="/data"

# XDG Base Directory
export XDG_LOCAL_HOME="$HOME/.local"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Relocate variables
#export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
# export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
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
export TASKRC="$XDG_CONFIG_HOME/task/taskrc"
export TASKDATA="$XDG_DATA_HOME/task"

# Npm path
export PATH="$XDG_DATA_HOME/npm/bin:$PATH"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

# Misc
export HISTSIZE=1000
export SAVEHIST=1000
export HISTFILE="$ZDOTDIR/.history"
export LESSHISTFILE="-"
export SUDO_ASKPASS="$HOME/.local/bin/rofipass"
export SUDO_PROMPT="[sudo] password for %p: "
# export SPROMPT="%F{blue}[%fzsh%F{blue}]%f correct %F{red}%R%f to %F{blue}%r%f [nyae]: "

# Fzf
export FZF_DEFAULT_OPTS_FILE="$XDG_CONFIG_HOME/fzf/themes/onedark"
export FZF_DEFAULT_OPTS="
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

# NOTE: Set Qt to use GTK theme (For now this breaks kdenlive, shotcut)

# export QT_QPA_PLATFORMTHEME="gtk2"
# export QT_QPA_PLATFORMTHEME="qt6ct"

# Scaling
export QT_SCALE_FACTOR=1.25
export GDK_DPI_SCALE=1.25

# Enable if using qutebrowser for DRM Content
# export QTWEBENGINE_CHROMIUM_FLAGS="--widevine-path=/usr/lib/chromium/libwidevinecdm.so"

# Mozilla zoom in and out
export MOZ_USE_XINPUT2=1

# Shortcuts
[ ! -f "$XDG_CONFIG_HOME/shell/shrc" ] && setsid -f shortcuts >/dev/null 2>&1
