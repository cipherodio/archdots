from libqtile import hook

from bars.onedark import screens  # noqa: F401
from modules.floating import floating_layout  # noqa: F401
from modules.groups import groups  # noqa: F401
from modules.keys import keys, mod  # noqa: F401
from modules.layouts import layouts  # noqa: F401
from modules.mouse import mouse  # noqa: F401
from modules.rules import dgroups_app_rules  # noqa: F401

follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wmname = "Qtile"


# This will change your pointer cursor to the standard cursor
# you chose in your .Xresources file on Qtile.
@hook.subscribe.startup
def runner():
    import subprocess

    subprocess.Popen(["xsetroot", "-cursor_name", "left_ptr"])
