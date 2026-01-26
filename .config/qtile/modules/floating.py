from libqtile import layout
from libqtile.config import Match
from utils.colors import onedark

floating_theme = {
    "border_width": 3,
    "border_focus": onedark["c12"],
    "border_normal": onedark["c01"],
}


floating_layout = layout.Floating(
    **floating_theme,
    float_rules=[
        *layout.Floating.default_float_rules,
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
)

# Last Modified: Mon, 26 Jan 2026 05:32:13 PM
