from libqtile.config import Key
from libqtile.lazy import lazy

mod = "mod4"
altmod = "mod1"
terminal = "alacritty"
mvol = "pulsemixer --toggle-mute"
# upvol = "pactl set-sink-volume 0 +5%"
# downvol = "pactl set-sink-volume 0 -5%"
# upvol = "pulsemixer --change-volume +5 --max-volume 150"
# downvol = "pulsemixer --change-volume -5 --max-volume 150"
brightup = "brightnessctl set +10%"
brightdown = "brightnessctl set 10%-"
powermenu = "power"
rofi = "rofi -show drun"
filemanager = "alacritty -e lf"
browser = "firefox"
qbrowser = "qutebrowser"
emacs = "emacsclient -c -a 'emacs' "
mpctoggle = "mpc toggle"
mpcprev = "mpc prev"
mpcnext = "mpc next"

keys = [
    # Navigation
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key(
        [mod], "Tab", lazy.screen.toggle_group(), desc="Switch last view group"
    ),
    # Shuffle window
    Key(
        [mod, "control"],
        "h",
        lazy.layout.shuffle_left(),
        desc="Suffle to left",
    ),
    Key(
        [mod, "control"],
        "l",
        lazy.layout.shuffle_right(),
        desc="Shuffle to right",
    ),
    Key(
        [mod, "control"], "j", lazy.layout.shuffle_down(), desc="Shuffle down"
    ),
    Key([mod, "control"], "k", lazy.layout.shuffle_up(), desc="Shuffle up"),
    # Adjust window
    Key([mod, "shift"], "h", lazy.layout.grow_left(), desc="Grow to left"),
    Key([mod, "shift"], "l", lazy.layout.grow_right(), desc="Grow to right"),
    Key([mod, "shift"], "j", lazy.layout.grow_down(), desc="Grow down"),
    Key([mod, "shift"], "k", lazy.layout.grow_up(), desc="Grow up"),
    Key(
        [mod, "control"],
        "space",
        lazy.layout.normalize(),
        desc="Reset all window",
    ),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Fullscreen toggle"),
    # Media keys
    Key([], "XF86AudioMute", lazy.spawn(mvol), desc="Mute volume"),
    # Key([], "XF86AudioRaiseVolume", lazy.spawn(upvol), desc="Volume Up"),
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("audiobar 0 +5"),
        desc="Volume Up",
    ),
    # Key([], "XF86AudioLowerVolume", lazy.spawn(downvol), desc="volume down"),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("audiobar 0 -5"),
        desc="volume down",
    ),
    Key([], "XF86MonBrightnessUp", lazy.spawn(brightup), desc="Brightness up"),
    Key(
        [],
        "XF86MonBrightnessDown",
        lazy.spawn(brightdown),
        desc="Brightness up",
    ),
    Key(
        [],
        "XF86TouchpadToggle",
        lazy.spawn("padtoggle"),
        desc="Toggle touchpad",
    ),
    # System
    Key([altmod], "b", lazy.hide_show_bar(), desc="Toggle qtile bar"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focus window"),
    Key(
        [mod, "control"],
        "r",
        lazy.reload_config(),
        desc="Reload configuration",
    ),
    Key([mod], "escape", lazy.spawn(powermenu), desc="Power menu"),
    Key([mod], "i", lazy.next_layout(), desc="Toggle layouts"),
    Key([mod, "control"], "x", lazy.shutdown(), desc="Shutdown qtile"),
    # Programs
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "d", lazy.spawn(rofi), desc="Rofi"),
    Key([mod], "o", lazy.spawn(filemanager), desc="File manager lf"),
    Key([mod], "b", lazy.spawn(browser), desc="Firefox web browser"),
    Key([mod, "shift"], "b", lazy.spawn(qbrowser), desc="Qute web browser"),
    Key([mod], "F2", lazy.spawn("podconnect"), desc="Connect airpods"),
    Key([mod], "F1", lazy.spawn("ekill"), desc="Emacs daemon toggle"),
    Key([mod], "e", lazy.spawn(emacs), desc="Emacs"),
    Key([mod], "F4", lazy.spawn("ekill"), desc="Restart Emacs server"),
    Key([mod], "grave", lazy.spawn("emojis"), desc="Emojis"),
    Key([], "Print", lazy.spawn("screenshot"), desc="Take screenshot"),
    Key([mod], "Print", lazy.spawn("timeshot"), desc="Timed screenshot"),
    Key(
        [mod],
        "s",
        lazy.spawn("spotify-toggle"),
        desc="Play toggle for spotify",
    ),
    Key(
        [mod],
        "period",
        lazy.spawn("spotify-next"),
        desc="Next song in spotify",
    ),
    Key(
        [mod],
        "comma",
        lazy.spawn("spotify-prev"),
        desc="Previous song in spotify",
    ),
    Key(
        [mod, "shift"],
        "s",
        lazy.spawn("mpcplaylist"),
        desc="Search ncmpcpp song",
    ),
    Key(
        [mod, "shift"],
        "p",
        lazy.spawn(mpctoggle),
        desc="Play toggle for ncmpcpp",
    ),
    Key(
        [mod, "shift"],
        "comma",
        lazy.spawn(mpcprev),
        desc="Previous song in ncmpcpp",
    ),
    Key(
        [mod, "shift"],
        "period",
        lazy.spawn(mpcnext),
        desc="Next song in ncmpcpp",
    ),
    Key([mod], "F9", lazy.spawn("mounter"), desc="Mount drive"),
    Key([mod, "shift"], "F9", lazy.spawn("unmounter"), desc="Unmount drive"),
    Key([mod], "w", lazy.spawn("bookmarklink"), desc="Web search via rofi"),
    Key([mod], "F12", lazy.spawn("torrtoggle"), desc="Torrent daemon toggle"),
    Key(
        [mod, "shift"],
        "F12",
        lazy.spawn("torrclear"),
        desc="Remove finished torrent",
    ),
    Key([mod], "p", lazy.spawn("picomtoggle"), desc="Picom toggle"),
    Key([mod], "g", lazy.spawn("gameon"), desc="Toggle Picom and Unclutter"),
    Key([mod], "c", lazy.spawn("camtoggle"), desc="Webcam toggle"),
    Key(
        [mod, "shift"],
        "c",
        lazy.spawn("cluttertoggle"),
        desc="Unclutter toggle",
    ),
    Key([mod], "F8", lazy.spawn("screencast"), desc="Record screen"),
]

keys.extend(
    [
        Key(
            [mod, "shift"],
            "Return",
            lazy.group["scratchpad"].dropdown_toggle("term"),
            desc="Terminal scratchpad",
        ),
        Key(
            [mod, "shift"],
            "w",
            lazy.group["scratchpad"].dropdown_toggle("nmtui"),
            desc="Open nmtui",
        ),
        Key(
            [altmod, "shift"],
            "s",
            lazy.group["scratchpad"].dropdown_toggle("spotify"),
            desc="Spotify scratchpad",
        ),
        Key(
            [altmod, "shift"],
            "b",
            lazy.group["scratchpad"].dropdown_toggle("btop"),
            desc="Btop system monitor",
        ),
        Key(
            [altmod, "shift"],
            "h",
            lazy.group["scratchpad"].dropdown_toggle("htop"),
            desc="Htop system monitor",
        ),
        Key(
            [altmod, "shift"],
            "n",
            lazy.group["scratchpad"].dropdown_toggle("nvtop"),
            desc="Nvtop gpu monitor",
        ),
        Key(
            [altmod, "shift"],
            "p",
            lazy.group["scratchpad"].dropdown_toggle("pulsemixer"),
            desc="Audio mixer",
        ),
        Key(
            [altmod, "shift"],
            "m",
            lazy.group["scratchpad"].dropdown_toggle("ncmpcpp"),
            desc="Ncmpcpp music player",
        ),
        Key(
            [altmod],
            "t",
            lazy.group["scratchpad"].dropdown_toggle("tremc"),
            desc="Torrent tremc",
        ),
    ]
)
