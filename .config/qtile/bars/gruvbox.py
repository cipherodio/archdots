from libqtile import bar, qtile, widget
from libqtile.config import Screen
from utils.colors import gruvdark

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
    widget.Spacer(length=15, background=gruvdark["c01"]),
    # widget.Image(
    #     background=gruvdark["c01"],
    #     filename="~/.config/qtile/assets/logo/python-gruvbox.png",
    # ),
    widget.Image(
        background=gruvdark["c01"],
        filename="~/.config/qtile/assets/icons/clock.png",
        margin_x=5,
        margin_y=6,
    ),
    widget.Clock(
        **widget_defaults,
        background=gruvdark["c01"],
        foreground=gruvdark["c12"],
        format="%I:%M %p",
    ),
    widget.Image(
        background=gruvdark["c01"],
        filename="~/.config/qtile/assets/icons/calendar.png",
        margin_x=5,
        margin_y=6,
    ),
    widget.Clock(
        **widget_defaults,
        background=gruvdark["c01"],
        foreground=gruvdark["c12"],
        format="%a %d %b",
    ),
    widget.Image(filename="~/.config/qtile/assets/background/curveright.png"),
    widget.GroupBox(
        **widget_defaults,
        background=gruvdark["c13"],
        active=gruvdark["c02"],
        inactive=gruvdark["c12"],
        this_current_screen_border=gruvdark["c13"],
        block_highlight_text_color=gruvdark["c03"],
    ),
    widget.Spacer(length=8, background=gruvdark["c13"]),
    widget.Image(filename="~/.config/qtile/assets/background/slopeleft.png"),
    widget.CurrentLayout(
        background=gruvdark["c13"],
        scale=0.50,
        mode="icon",
        custom_icon_paths=["~/.config/qtile/assets/layouts/"],
    ),
    widget.Image(filename="~/.config/qtile/assets/background/curveleft.png"),
    widget.Image(
        background=gruvdark["c01"],
        filename="~/.config/qtile/assets/icons/window.png",
        margin_x=5,
        margin_y=6,
    ),
    widget.WindowName(
        **widget_defaults,
        background=gruvdark["c01"],
        foreground=gruvdark["c12"],
        max_chars=51,
    ),
    widget.Image(filename="~/.config/qtile/assets/background/curveright.png"),
    widget.Systray(
        **widget_defaults, background=gruvdark["c13"], icon_size=18
    ),
    widget.Spacer(length=15, background=gruvdark["c13"]),
    widget.Image(
        background=gruvdark["c13"],
        filename="~/.config/qtile/assets/icons/wifi.png",
        margin_x=5,
        margin_y=6,
    ),
    widget.Wlan(
        **widget_defaults,
        background=gruvdark["c13"],
        foreground=gruvdark["c12"],
        format="{essid}",
        interface="wlan0",
    ),
    widget.Image(filename="~/.config/qtile/assets/background/sloperight.png"),
    widget.Image(
        background=gruvdark["c13"],
        filename="~/.config/qtile/assets/icons/ram.png",
        margin_x=5,
        margin_y=6,
    ),
    widget.Memory(
        **widget_defaults,
        background=gruvdark["c13"],
        foreground=gruvdark["c12"],
        format="{MemPercent:.0f}%",
        # format="{MemUsed: .0f}{mm}",
        # measure_mem="G",
    ),
    widget.Image(filename="~/.config/qtile/assets/background/sloperight.png"),
    widget.Image(
        background=gruvdark["c13"],
        filename="~/.config/qtile/assets/icons/brightness.png",
        margin_x=5,
        margin_y=6,
    ),
    widget.Backlight(
        **widget_defaults,
        background=gruvdark["c13"],
        foreground=gruvdark["c12"],
        backlight_name="amdgpu_bl2",
    ),
    widget.Image(filename="~/.config/qtile/assets/background/sloperight.png"),
    # original place of battery
    widget.PulseVolume(
        **widget_defaults,
        background=gruvdark["c13"],
        theme_path="~/.config/qtile/assets/volume/",
        emoji=True,
    ),
    widget.PulseVolume(
        **widget_defaults,
        background=gruvdark["c13"],
        foreground=gruvdark["c12"],
        mute_format="0%",
    ),
    widget.Image(filename="~/.config/qtile/assets/background/curveleft.png"),
    # original place of pulse
    widget.BatteryIcon(
        background=gruvdark["c01"],
        theme_path="~/.config/qtile/assets/battery/",
        scale=0.8,
    ),
    widget.Battery(
        **widget_defaults,
        background=gruvdark["c01"],
        foreground=gruvdark["c12"],
        format="{percent:2.0%}",
        notify_below=20,
    ),
    widget.Spacer(length=15, background=gruvdark["c01"]),
]

screens = [Screen(top=bar.Bar(mainbar, size=34))]
