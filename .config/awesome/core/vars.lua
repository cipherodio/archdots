local awful = require("awful")

awful.util.shell = "/bin/sh"

-- Mod4 is the Super / Windows key (between Ctrl and Alt on most keyboards).
-- This is already the "super" key — no remap needed at the awesome level.
-- If it doesn't register, check that your key isn't rebound elsewhere (xmodmap).
modkey = "Mod4"
altkey = "Mod1"

-- Default terminal and editor
terminal = os.getenv("TERMINAL")
editor = os.getenv("EDITOR")
emacscmd = "emacsclient -c -a emacs"
browser = os.getenv("BROWSER")
-- editor_cmd = terminal .. " -e " .. editor

-- Table of layouts to cycle through with modkey+space / modkey+shift+space
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.floating,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
}
