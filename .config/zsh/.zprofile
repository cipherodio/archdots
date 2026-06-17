export XINITRC="$XDG_CONFIG_HOME/xorg/xinitrc"
# export XLOG="$XDG_CACHE_HOME/xorg.log"
# [ "$(tty)" = "/dev/tty1" ] && ! pidof -s Xorg >/dev/null 2>&1 && exec startx "$XINITRC" > "$XLOG" 2>&1

if [ "$(tty)" = "/dev/tty1" ] && ! pgrep -x Xorg >/dev/null 2>&1; then
    # mkdir -p "$XDG_CACHE_HOME"
    exec startx "$XINITRC" >"$XDG_CACHE_HOME/xorg.log" 2>&1
fi
