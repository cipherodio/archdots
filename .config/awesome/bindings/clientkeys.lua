local awful = require("awful")
local gears = require("gears")

clientkeys = gears.table.join(
    -- Toggle fullscreen
    awful.key({ modkey }, "f", function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, { description = "toggle fullscreen", group = "client" }),
    -- Close focused window
    awful.key({ modkey }, "q", function(c)
        c:kill()
    end, { description = "close", group = "client" }),
    -- Toggle focused window between floating and tiled
    awful.key(
        { modkey, "Control" },
        "space",
        awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }
    ),
    -- Swap the focused window with whatever is currently in the master slot
    awful.key({ modkey, "Control" }, "Return", function(c)
        c:swap(awful.client.getmaster())
    end, { description = "move to master", group = "client" })
    -- Multi monitor
    -- Move the focused window to the next physical monitor
    -- awful.key({ modkey, "Shift" }, "Right", function(c)
    --     c:move_to_screen()
    -- end, { description = "move to next monitor", group = "client" })
)
