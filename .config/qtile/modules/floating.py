from libqtile import layout
from libqtile.config import Match
from utils.colors import onedark

floating_theme = {
    "border_width": 1,
    "border_focus": onedark["c05"],
    "border_normal": onedark["c00"],
}


floating_layout = layout.Floating(
    **floating_theme,
    float_rules=[
        *layout.Floating.default_float_rules,
        # Generic GTK file chooser dialogs (Open/save dialogs)
        Match(role="GtkFileChooserDialog"),
        # Common modal dialogs
        Match(role="dialog"),
        Match(role="pop-up"),
        # Password and authentication prompts
        Match(wm_class="ssh-askpass"),
        Match(title="pinentry"),
        Match(wm_class="Pinentry-gtk"),
        # Version control and git dialogs
        Match(wm_class="confirmreset"),
        Match(wm_class="makebranch"),
        Match(wm_class="maketag"),
        Match(title="branchdialog"),
        # Steam dialogs
        Match(wm_class="Steam setup"),
        Match(title="Steam Settings"),
        # Spotify download dialogs
        Match(title="Downloading spotify"),
        # Zenity dialogs
        Match(wm_class="zenity"),
    ],
)
