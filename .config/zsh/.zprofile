export XINITRC="$XDG_CONFIG_HOME/xorg/xinitrc"
export XLOG="$XDG_CACHE_HOME/xorg.log"
[ "$(tty)" = "/dev/tty1" ] && ! pidof -s Xorg >/dev/null 2>&1 && exec startx "$XINITRC" > "$XLOG" 2>&1
