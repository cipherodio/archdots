import re

from libqtile.config import Match, Rule

dgroups_key_binder = None
dgroups_app_rules = [
    Rule(Match(wm_class=re.compile(r"^(firefox)$")), group="1"),
    Rule(Match(wm_class=re.compile(r"^(Steam|steam)$")), group="4"),
    Rule(Match(title=re.compile(r"^(Steam\ setup|Steam|steam)$")), group="4"),
]
