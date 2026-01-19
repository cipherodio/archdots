from libqtile import layout
from utils.colors import onedark

# Layouts
layout_theme = {
    "border_width": 3,
    "border_focus": onedark["c12"],
    "border_normal": onedark["c01"],
}

layouts = [
    layout.Columns(
        **layout_theme, shift_windows=True, margin=5, border_on_single=True
    ),
    layout.MonadTall(
        **layout_theme, ratio=0.25, new_client_position="before_current"
    ),
    layout.MonadWide(**layout_theme),
    # layout.Max(**layout_theme),
    # layout.Tile(**layout_theme),
    # layout.Bsp(**layout_theme),
]

# Last Modified: Sun, 18 Jan 2026 03:06:08 PM
