import os

from libqtile import bar, widget
from libqtile.config import Screen
from libqtile.lazy import lazy

from utils.colors import nord

# Helper
assets = os.path.expanduser("~/.config/qtile/assets")

# Widgets
widget_texts = dict(
    font="monospace",
    fontsize=20,
    padding=5,
)
widget_defaults = dict(
    font="monospace",
    fontsize=18,
    padding=5,
)
extension_defaults = widget_defaults.copy()

mainbar = [
    widget.Spacer(length=15, background=nord["c00"]),
    widget.TextBox(
        **widget_texts,
        text="󰥔",
        background=nord["c00"],
        foreground=nord["c04"],
    ),
    widget.Clock(
        **widget_defaults,
        background=nord["c00"],
        foreground=nord["c04"],
        format="%I:%M %p",
    ),
    widget.TextBox(
        text=" ",
        background=nord["c00"],
    ),
    widget.TextBox(
        **widget_texts,
        text="󰸗",
        background=nord["c00"],
        foreground=nord["c04"],
    ),
    widget.Clock(
        **widget_defaults,
        background=nord["c00"],
        foreground=nord["c04"],
        format="%a %d %b",
        mouse_callbacks={"Button1": lazy.spawn("calaptnotify")},
    ),
    widget.Image(filename=f"{assets}/bg/curveright.png"),
    widget.GroupBox(
        **widget_defaults,
        background=nord["c01"],
        active=nord["c04"],
        inactive=nord["c06"],
        this_current_screen_border=nord["c04"],
        urgent_alert_method="text",
        urgent_text=nord["c02"],
        highlight_method="line",
        highlight_color=[nord["c01"], nord["c01"]],
    ),
    widget.Spacer(length=8, background=nord["c01"]),
    widget.Image(filename=f"{assets}/bg/slopeleft.png"),
    widget.CurrentLayout(
        **widget_defaults,
        background=nord["c01"],
        scale=0.50,
        mode="icon",
        custom_icon_paths=[f"{assets}/layouts/"],
    ),
    widget.Image(filename=f"{assets}/bg/curveleft.png"),
    widget.WindowName(
        **widget_defaults,
        background=nord["c00"],
        foreground=nord["c04"],
        max_chars=51,
    ),
    widget.Image(filename=f"{assets}/bg/curveright.png"),
    widget.Systray(**widget_defaults, background=nord["c01"], icon_size=18),
    widget.Spacer(length=15, background=nord["c01"]),
    widget.TextBox(
        **widget_texts,
        text="󰢾",
        background=nord["c01"],
        foreground=nord["c04"],
    ),
    widget.Wlan(
        **widget_defaults,
        background=nord["c01"],
        foreground=nord["c04"],
        format="{percent:2.0%}",
        interface="wlan0",
        mouse_callbacks={"Button1": lazy.spawn("ssidnotify")},
    ),
    widget.Image(filename=f"{assets}/bg/sloperight.png"),
    widget.TextBox(
        **widget_texts,
        text="󰍛",
        background=nord["c01"],
        foreground=nord["c04"],
    ),
    widget.Memory(
        **widget_defaults,
        background=nord["c01"],
        foreground=nord["c04"],
        format="{MemPercent:.0f}%",
    ),
    widget.Image(filename=f"{assets}/bg/sloperight.png"),
    widget.TextBox(
        **widget_texts,
        text="󰃟",
        background=nord["c01"],
        foreground=nord["c04"],
    ),
    widget.Backlight(
        **widget_defaults,
        background=nord["c01"],
        foreground=nord["c04"],
        backlight_name="amdgpu_bl2",
    ),
    widget.Image(filename=f"{assets}/bg/sloperight.png"),
    widget.TextBox(
        **widget_texts,
        text="󰕾",
        background=nord["c01"],
        foreground=nord["c04"],
    ),
    widget.Volume(
        **widget_defaults,
        update_interval=0.1,
        background=nord["c01"],
        foreground=nord["c04"],
        mute_format="0%",
        step=5,
    ),
    widget.Image(filename=f"{assets}/bg/curveleft.png"),
    widget.TextBox(
        **widget_texts,
        text=" ",
        background=nord["c00"],
        foreground=nord["c04"],
    ),
    widget.Battery(
        **widget_defaults,
        background=nord["c00"],
        foreground=nord["c04"],
        format="{percent:2.0%}",
        notify_below=20,
    ),
    widget.Spacer(length=15, background=nord["c00"]),
]

screens = [Screen(top=bar.Bar(mainbar, size=34))]
