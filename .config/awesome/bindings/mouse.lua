local gears = require("gears")
local awful = require("awful")

-- No right-click menu popup (mymainmenu removed) — just scroll to switch tags.
root.buttons(gears.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
