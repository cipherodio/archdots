from libqtile import layout
from libqtile.config import Match
from utils.colors import gruvdark

# Layouts
layout_theme = {
    "border_width": 3,
    "border_focus": gruvdark["c02"],
    "border_normal": gruvdark["c01"],
}
floating_theme = layout_theme.copy()

layouts = [
    layout.Columns(
        **layout_theme, shift_windows=True, margin=5, border_on_single=True
    ),
    layout.Floating(**layout_theme),
    layout.MonadTall(
        **layout_theme, ratio=0.25, new_client_position="before_current"
    ),
    layout.MonadWide(**layout_theme),
    # layout.Max(**layout_theme),
    # layout.Tile(**layout_theme),
    # layout.Bsp(**layout_theme),
]

floating_layout = layout.Floating(
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class="Alacritty"),
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),
        Match(title="pinentry"),
        Match(wm_class="Steam setup"),
        Match(title="Steam Settings"),
        Match(title="Downloading spotify"),
        Match(wm_class="zenity"),
    ],
    **floating_theme,
)

# Last Modified: Thu, 08 Jan 2026 02:13:01 AM
