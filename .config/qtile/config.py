from libqtile import hook

from bars.onedark import screens as screens
from modules.floating import floating_layout as floating_layout
from modules.groups import groups as groups
from modules.keys import keys as keys
from modules.keys import mod as mod
from modules.layouts import layouts as layouts
from modules.mouse import mouse as mouse
from modules.rules import dgroups_app_rules as dgroups_app_rules

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
