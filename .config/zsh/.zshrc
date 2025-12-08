# shellcheck disable=2034,2016,1091
# Prompt with git branch and git changes
setopt prompt_subst
autoload -Uz vcs_info
autoload -U add-zsh-hook
add-zsh-hook precmd vcs_info

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' formats '%F{magenta} %f %F{yellow}%b%f%F{red}%u%f%F{green}%c%f '
zstyle ':vcs_info:*' unstagedstr ' [!]'
zstyle ':vcs_info:*' stagedstr ' [+]'

PROMPT='%F{blue}%B%~%b%f %B${vcs_info_msg_0_}%b> '

# Install fzf
if [ ! -d ~/.config/fzf ]; then
    git clone --depth 1 https://github.com/junegunn/fzf ~/.config/fzf
    ~/.config/fzf/install --no-bash --no-fish --xdg --all
fi

# Install zsh-fast-syntax-highlighting
if [ ! -d "$ZPLUG"/fasthl ]; then
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting "$ZPLUG"/fasthl
fi

# Install zsh-auto-suggestions
if [ ! -d "$ZPLUG"/auto-suggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZPLUG"/auto-suggestions
fi

# Install zsh-system-clipboard
if [ ! -d "$ZPLUG"/system-clipboard ]; then
    git clone https://github.com/kutsan/zsh-system-clipboard "$ZPLUG"/system-clipboard
fi

# Load aliases and shortcuts if it exist
[ -f "$XDG_CONFIG_HOME/shell/shrc" ] && source "$XDG_CONFIG_HOME/shell/shrc"
[ -f "$XDG_CONFIG_HOME/shell/aliasrc" ] && source "$XDG_CONFIG_HOME/shell/aliasrc"
[ -f "$XDG_CONFIG_HOME/shell/zshdirrc" ] && source "$XDG_CONFIG_HOME/shell/zshdirrc"

# Shell opts
setopt glob_dots
setopt extended_glob
setopt auto_cd
setopt interactive_comments
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_all_dups
setopt no_nomatch

# Tab completion
autoload -U compinit && compinit -u
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'
zmodload zsh/complist

# Vi mode
bindkey -v
export KEYTIMEOUT=1

# Vim keys in tab completion
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

# Change cursor style for different vi modes
function zle-keymap-select() {
    case $KEYMAP in
    # block
    vicmd) echo -ne '\e[1 q' ;;
    # beam
    viins | main) echo -ne '\e[5 q' ;;
    esac
}
zle -N zle-keymap-select

# Initiate `vi insert` as keymap
# Can be removed if `bindkey -V` has been set elsewhere
zle-line-init() {
    zle -K viins && echo -ne "\e[5 q"
}
zle -N zle-line-init

# Use beam cursor on startup
echo -ne '\e[5 q'

# Command not found
function command_not_found_handler() {
    print -P "Error: %F{124}$0%f" >&2
    return 127
}

# Do cd then ls
cd() {
    new_directory="$*"
    if [ $# -eq 0 ]; then
        new_directory=${HOME}
    fi
    builtin cd "${new_directory}" && ls -AhN --color=auto --group-directories-first
}

# Use lf to jump in directories with ctrl-o
# shellcheck disable=2164
lfcd() {
    tmp="$(mktemp -uq)"
    trap 'rm -f $tmp >/dev/null 2>&1 &&
        trap - HUP INT QUIT TERM PWR EXIT' HUP INT QUIT TERM PWR EXIT
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s "^o" "^ulfcd\n"

# Search $HOME with fzf and open in $EDITOR with alt-e
editfile() {
    rg "$HOME" --files | sort -u | fzf -m | xargs -r "$EDITOR"
}
bindkey -s "^[e" "^ueditfile\n"

# Search in $HOME with fzf and cd to that directory with alt-d
jumptodirectory() {
    cd "$(rg "$HOME" -0 --files | xargs -0 dirname | sort -u | fzf)" || exit
}
bindkey -s "^[d" "^ujumptodirectory\n"

# Source fzf
if [[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ]]; then
    source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh
fi

# Source zsh-auto-suggestions
source "$ZPLUG"/auto-suggestions/zsh-autosuggestions.zsh

# Source zsh-system-clipboard
source "$ZPLUG"/system-clipboard/zsh-system-clipboard.zsh

# Source zsh-fast-syntax-highlighting
source "$ZPLUG"/fasthl/fast-syntax-highlighting.plugin.zsh

# Last Modified: Mon, 08 Dec 2025 08:25:52 PM
