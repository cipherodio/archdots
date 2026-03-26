from libqtile import hook

from modules.bars import screens
from modules.floating import floating_layout
from modules.groups import groups
from modules.keys import keys, mod
from modules.layouts import layouts
from modules.mouse import mouse
from modules.rules import dgroups_app_rules
from utils.colors import onedark

follow_mouse_focus = False
bring_front_click = False
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wmname = "LG3D"


# This will change your pointer cursor to the standard cursor
# you chose in your .Xresources file on Qtile.
@hook.subscribe.startup_once
def runner():
    import subprocess

    subprocess.Popen(["xsetroot", "-cursor_name", "left_ptr"])
