export XINITRC="$XDG_CONFIG_HOME/xorg/xinitrc"

if [ "$(tty)" = "/dev/tty1" ] && ! pgrep -x Xorg >/dev/null 2>&1; then
    mkdir -p "$XDG_CACHE_HOME"
    exec startx "$XINITRC" >"$XDG_CACHE_HOME/xorg.log" 2>&1
fi
