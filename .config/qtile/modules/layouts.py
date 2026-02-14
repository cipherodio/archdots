from libqtile import layout
from utils.colors import onedark

# Layouts
layout_theme = {
    "border_width": 2,
    "border_focus": onedark["c05"],
    "border_normal": onedark["c00"],
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
