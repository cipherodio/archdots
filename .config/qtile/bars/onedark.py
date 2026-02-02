from libqtile import bar, qtile, widget
from libqtile.config import Screen
from libqtile.lazy import lazy
from utils.colors import onedark

# Widgets
widget_defaults = dict(
    font="monospace Bold",
    fontsize=18,
    padding=5,
)
extension_defaults = widget_defaults.copy()


def power():
    qtile.cmd_spawn("power")


mainbar = [
    widget.Spacer(length=15, background=onedark["c01"]),
    widget.Image(
        background=onedark["c01"],
        filename="~/.config/qtile/assets/onedark/icons/clock.png",
        margin_x=5,
        margin_y=6,
    ),
    widget.Clock(
        **widget_defaults,
        background=onedark["c01"],
        foreground=onedark["c09"],
        # format="%I:%M %p",
        format="%H:%M | %I:%M %p",
    ),
    widget.Image(
        background=onedark["c01"],
        filename="~/.config/qtile/assets/onedark/icons/calendar.png",
        margin_x=5,
        margin_y=6,
    ),
    widget.Clock(
        **widget_defaults,
        background=onedark["c01"],
        foreground=onedark["c09"],
        format="%a %d %b",
        mouse_callbacks={"Button1": lazy.spawn("calaptnotify")},
    ),
    widget.Image(
        filename="~/.config/qtile/assets/onedark/background/curveright.png"
    ),
    widget.GroupBox(
        **widget_defaults,
        background=onedark["c02"],
        active=onedark["c03"],
        inactive=onedark["c09"],
        this_current_screen_border=onedark["c02"],
        block_highlight_text_color=onedark["c04"],
    ),
    widget.Spacer(length=8, background=onedark["c02"]),
    widget.Image(
        filename="~/.config/qtile/assets/onedark/background/slopeleft.png"
    ),
    widget.CurrentLayout(
        background=onedark["c02"],
        scale=0.50,
        mode="icon",
        custom_icon_paths=["~/.config/qtile/assets/onedark/layouts/"],
    ),
    widget.Image(
        filename="~/.config/qtile/assets/onedark/background/curveleft.png"
    ),
    widget.Image(
        background=onedark["c01"],
        filename="~/.config/qtile/assets/onedark/icons/window.png",
        margin_x=5,
        margin_y=6,
    ),
    widget.WindowName(
        **widget_defaults,
        background=onedark["c01"],
        foreground=onedark["c09"],
        max_chars=51,
    ),
    widget.Image(
        filename="~/.config/qtile/assets/onedark/background/curveright.png"
    ),
    widget.Systray(**widget_defaults, background=onedark["c02"], icon_size=18),
    widget.Spacer(length=15, background=onedark["c02"]),
    widget.Image(
        background=onedark["c02"],
        filename="~/.config/qtile/assets/onedark/icons/wifi.png",
        margin_x=5,
        margin_y=6,
    ),
    widget.Wlan(
        **widget_defaults,
        background=onedark["c02"],
        foreground=onedark["c09"],
        format="{essid}",
        interface="wlan0",
    ),
    widget.Image(
        filename="~/.config/qtile/assets/onedark/background/sloperight.png"
    ),
    widget.Image(
        background=onedark["c02"],
        filename="~/.config/qtile/assets/onedark/icons/ram.png",
        margin_x=5,
        margin_y=6,
    ),
    widget.Memory(
        **widget_defaults,
        background=onedark["c02"],
        foreground=onedark["c09"],
        format="{MemPercent:.0f}%",
        # format="{MemUsed: .0f}{mm}",
        # measure_mem="G",
    ),
    widget.Image(
        filename="~/.config/qtile/assets/onedark/background/sloperight.png"
    ),
    widget.Image(
        background=onedark["c02"],
        filename="~/.config/qtile/assets/onedark/icons/brightness.png",
        margin_x=5,
        margin_y=6,
    ),
    widget.Backlight(
        **widget_defaults,
        background=onedark["c02"],
        foreground=onedark["c09"],
        backlight_name="amdgpu_bl2",
    ),
    widget.Image(
        filename="~/.config/qtile/assets/onedark/background/sloperight.png"
    ),
    # original place of battery
    widget.PulseVolume(
        **widget_defaults,
        background=onedark["c02"],
        theme_path="~/.config/qtile/assets/onedark/volume/",
        emoji=True,
    ),
    widget.PulseVolume(
        **widget_defaults,
        background=onedark["c02"],
        foreground=onedark["c09"],
        mute_format="0%",
    ),
    widget.Image(
        filename="~/.config/qtile/assets/onedark/background/curveleft.png"
    ),
    # original place of pulse
    widget.BatteryIcon(
        background=onedark["c01"],
        theme_path="~/.config/qtile/assets/onedark/battery/",
        scale=0.8,
    ),
    widget.Battery(
        **widget_defaults,
        background=onedark["c01"],
        foreground=onedark["c09"],
        format="{percent:2.0%}",
        notify_below=20,
    ),
    widget.Spacer(length=15, background=onedark["c01"]),
]

screens = [Screen(top=bar.Bar(mainbar, size=34))]
