from libqtile.config import DropDown, Group, Key, Match, ScratchPad
from libqtile.lazy import lazy

from .keys import keys, mod, terminal

groups = [Group(i) for i in "12345"]

for i in groups:
    keys.extend(
        [
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch & move focused window to group {}".format(i.name),
            ),
            Key(
                [mod, "control"],
                i.name,
                lazy.window.togroup(i.name),
                desc="move focused window to group {}".format(i.name),
            ),
        ]
    )

# Scratchpad
groups.append(
    ScratchPad(
        "scratchpad",
        [
            DropDown(
                "term",
                terminal,
                on_focus_lost_hide=False,
                warp_pointer=False,
                opacity=0.95,
                height=0.50,
                width=0.50,
                x=0.25,
                y=0.1,
            ),
            DropDown(
                "nmtui",
                terminal + " -e nmtui",
                on_focus_lost_hide=False,
                warp_pointer=False,
                opacity=1,
                height=0.50,
                width=0.40,
                x=0.30,
                y=0.18,
            ),
            DropDown(
                "spotify",
                "qtile run-cmd -g scratchpad spotify-launcher",
                match=Match(wm_class="Spotify"),
                on_focus_lost_hide=False,
                warp_pointer=False,
                opacity=1.00,
                height=0.50,
                width=0.50,
                x=0.25,
                y=0.1,
            ),
            DropDown(
                "btop",
                "alacritty --class sysmon -e btop",
                match=Match(wm_class="sysmon"),
                on_focus_lost_hide=False,
                warp_pointer=False,
                opacity=0.95,
                height=0.50,
                width=0.50,
                x=0.25,
                y=0.1,
            ),
            DropDown(
                "htop",
                "alacritty --class sysmon -e htop",
                match=Match(wm_class="sysmon"),
                on_focus_lost_hide=False,
                warp_pointer=False,
                opacity=0.95,
                height=0.50,
                width=0.50,
                x=0.25,
                y=0.1,
            ),
            DropDown(
                "nvtop",
                "alacritty --class sysmon -e nvtop",
                match=Match(wm_class="sysmon"),
                on_focus_lost_hide=False,
                warp_pointer=False,
                opacity=0.95,
                height=0.50,
                width=0.50,
                x=0.25,
                y=0.1,
            ),
            DropDown(
                "pulsemixer",
                "alacritty --class sysmon -e pulsemixer",
                match=Match(wm_class="sysmon"),
                on_focus_lost_hide=False,
                warp_pointer=False,
                opacity=0.95,
                height=0.50,
                width=0.50,
                x=0.25,
                y=0.1,
            ),
            DropDown(
                "ncmpcpp",
                terminal + " -e ncmpcpp",
                on_focus_lost_hide=False,
                warp_pointer=False,
                opacity=0.95,
                height=0.50,
                width=0.50,
                x=0.25,
                y=0.1,
            ),
            DropDown(
                "tremc",
                terminal + " -e tremc",
                on_focus_lost_hide=False,
                warp_pointer=False,
                opacity=0.95,
                height=0.50,
                width=0.50,
                x=0.25,
                y=0.1,
            ),
        ],
    )
)
