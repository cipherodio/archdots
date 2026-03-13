import os

from libqtile import bar, widget
from libqtile.config import Screen
from libqtile.lazy import lazy

from utils.colors import onedark

# Helper
home = os.path.expanduser("~")
assets = os.path.join(home, ".config/qtile/assets/onedark")

# Widgets
widget_defaults = dict(
    font="monospace",
    fontsize=18,
    padding=5,
)
extension_defaults = widget_defaults.copy()

mainbar = [
    widget.Spacer(length=15, background=onedark["c00"]),
    widget.Image(
        background=onedark["c00"],
        filename=f"{assets}/icons/clock.png",
        margin_x=5,
        margin_y=6,
    ),
    widget.Clock(
        **widget_defaults,
        background=onedark["c00"],
        foreground=onedark["c04"],
        format="%I:%M %p",
    ),
    widget.Image(
        background=onedark["c00"],
        filename=f"{assets}/icons/calendar.png",
        margin_x=5,
        margin_y=6,
    ),
    widget.Clock(
        **widget_defaults,
        background=onedark["c00"],
        foreground=onedark["c04"],
        format="%a %d %b",
        mouse_callbacks={"Button1": lazy.spawn("calaptnotify")},
    ),
    widget.Image(filename=f"{assets}/background/curveright.png"),
    widget.GroupBox(
        **widget_defaults,
        background=onedark["c01"],
        active=onedark["c02"],
        inactive=onedark["c04"],
        this_current_screen_border=onedark["c01"],
        block_highlight_text_color=onedark["c03"],
    ),
    widget.Spacer(length=8, background=onedark["c01"]),
    widget.Image(filename=f"{assets}/background/slopeleft.png"),
    widget.CurrentLayout(
        background=onedark["c01"],
        scale=0.50,
        mode="icon",
        custom_icon_paths=[f"{assets}/layouts/"],
    ),
    widget.Image(filename=f"{assets}/background/curveleft.png"),
    widget.Image(
        background=onedark["c00"],
        filename=f"{assets}/icons/window.png",
        margin_x=5,
        margin_y=6,
    ),
    widget.WindowName(
        **widget_defaults,
        background=onedark["c00"],
        foreground=onedark["c04"],
        max_chars=51,
    ),
    widget.Image(filename=f"{assets}/background/curveright.png"),
    widget.Systray(**widget_defaults, background=onedark["c01"], icon_size=18),
    widget.Spacer(length=15, background=onedark["c01"]),
    widget.Image(
        background=onedark["c01"],
        filename=f"{assets}/icons/wifi.png",
        margin_x=5,
        margin_y=6,
    ),
    widget.Wlan(
        **widget_defaults,
        background=onedark["c01"],
        foreground=onedark["c04"],
        format="{essid}",
        interface="wlan0",
    ),
    widget.Image(filename=f"{assets}/background/sloperight.png"),
    widget.Image(
        background=onedark["c01"],
        filename=f"{assets}/icons/ram.png",
        margin_x=5,
        margin_y=6,
    ),
    widget.Memory(
        **widget_defaults,
        background=onedark["c01"],
        foreground=onedark["c04"],
        format="{MemPercent:.0f}%",
    ),
    widget.Image(filename=f"{assets}/background/sloperight.png"),
    widget.Image(
        background=onedark["c01"],
        filename=f"{assets}/icons/brightness.png",
        margin_x=5,
        margin_y=6,
    ),
    widget.Backlight(
        **widget_defaults,
        background=onedark["c01"],
        foreground=onedark["c04"],
        backlight_name="amdgpu_bl2",
    ),
    widget.Image(filename=f"{assets}/background/sloperight.png"),
    # widget.PulseVolume(
    #     # name="volume_icon",
    #     # **widget_defaults,
    #     background=onedark["c01"],
    #     theme_path=f"{assets}/volume/",
    #     # emoji=True,
    # ),
    widget.Volume(
        **widget_defaults,
        background=onedark["c01"],
        theme_path=f"{assets}/volume/",
    ),
    widget.Volume(
        **widget_defaults,
        # fmt="  {}",
        update_interval=0.1,
        background="#31353f",
        foreground="#abb2bf",
        # background=onedark["c01"],
        # foreground=onedark["c04"],
    ),
    # widget.PulseVolume(
    #     # **widget_defaults,
    #     background=onedark["c01"],
    #     foreground=onedark["c04"],
    #     mute_format="0%",
    #     fmt="{}",
    #     unmuted_format="{volume}%",
    #     # BUG: https://github.com/qtile/qtile/issues/5747#event-21819025605
    #     mouse_callbacks={
    #         "Button1": lazy.widget["pulsevolume"].mute(),
    #         "Button4": lazy.widget["pulsevolume"].increase_vol(),
    #         "Button5": lazy.widget["pulsevolume"].decrease_vol(),
    #     },
    # ),
    widget.Image(filename=f"{assets}/background/curveleft.png"),
    widget.BatteryIcon(
        background=onedark["c00"],
        theme_path=f"{assets}/battery/",
        scale=0.8,
    ),
    widget.Battery(
        **widget_defaults,
        background=onedark["c00"],
        foreground=onedark["c04"],
        format="{percent:2.0%}",
        notify_below=20,
    ),
    widget.Spacer(length=15, background=onedark["c00"]),
]

screens = [Screen(top=bar.Bar(mainbar, size=34))]
