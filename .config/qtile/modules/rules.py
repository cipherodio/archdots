import re

from libqtile.config import Match, Rule

dgroups_key_binder = None
dgroups_app_rules = [
    Rule(Match(wm_class=re.compile(r"^(firefox)$")), group="1"),
    Rule(Match(wm_class=re.compile(r"^(Steam|steam)$")), group="4"),
    Rule(Match(title=re.compile(r"^(Steam\ setup|Steam|steam)$")), group="4"),
]

# Last Modified: Sat, 13 Dec 2025 03:20:10 PM
