local awful = require("awful")
local gears = require("gears")
local hotkeys_popup = require("awful.hotkeys_popup")
require("awful.hotkeys_popup.keys")

globalkeys = gears.table.join(
    -- Show the popup listing of every keybinds
    awful.key(
        { modkey },
        "F5",
        hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }
    ),
    -- Cycles previous tags
    awful.key(
        { modkey },
        "Left",
        awful.tag.viewprev,
        { description = "view previous", group = "tag" }
    ),
    -- Cycles next tags
    awful.key(
        { modkey },
        "Right",
        awful.tag.viewnext,
        { description = "view next", group = "tag" }
    ),
    -- Jump back to whichever tag you were on before the current tag
    awful.key(
        { modkey },
        "Tab",
        awful.tag.history.restore,
        { description = "go back", group = "tag" }
    ),

    -- Navigation
    awful.key({ modkey }, "h", function()
        awful.client.focus.bydirection("left")
        if client.focus then
            client.focus:raise()
        end
    end, { description = "focus left", group = "client" }),
    awful.key({ modkey }, "l", function()
        awful.client.focus.bydirection("right")
        if client.focus then
            client.focus:raise()
        end
    end, { description = "focus right", group = "client" }),
    awful.key({ modkey }, "j", function()
        awful.client.focus.byidx(1)
    end, { description = "focus next by index", group = "client" }),
    awful.key({ modkey }, "k", function()
        awful.client.focus.byidx(-1)
    end, { description = "focus previous by index", group = "client" }),

    -- Toggle statusbar
    awful.key({ altkey, "Control" }, "b", function()
        local s = awful.screen.focused()
        s.mywibox.visible = not s.mywibox.visible
    end, { description = "toggle statusbar", group = "awesome" }),

    -- Menu launcher that uses dmenu
    awful.key({ modkey }, "d", function()
        awful.spawn("menu")
    end, { description = "app launcher (dmenu)", group = "launcher" }),

    -- Swap focused client
    awful.key({ modkey, "Shift" }, "j", function()
        awful.client.swap.byidx(1)
    end, { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function()
        awful.client.swap.byidx(-1)
    end, { description = "swap with previous client by index", group = "client" }),
    -- Multi monitors
    -- awful.key({ modkey, "Control" }, "j", function()
    --     awful.screen.focus_relative(1)
    -- end, { description = "move focus to the next monitor", group = "screen" }),
    -- awful.key({ modkey, "Control" }, "k", function()
    --     awful.screen.focus_relative(-1)
    -- end, { description = "move focus the previous monitor", group = "screen" }),
    awful.key(
        { modkey },
        "u",
        awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }
    ),

    -- Standard program
    awful.key({ modkey }, "Return", function()
        awful.spawn(terminal)
    end, { description = "open a terminal", group = "launcher" }),
    awful.key(
        { modkey, "Control" },
        "r",
        awesome.restart,
        { description = "reload awesome", group = "awesome" }
    ),

    awful.key({ modkey, "Control" }, "l", function()
        awful.tag.incmwfact(0.05)
    end, { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey, "Control" }, "h", function()
        awful.tag.incmwfact(-0.05)
    end, { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, "Shift" }, "h", function()
        awful.tag.incnmaster(1, nil, true)
    end, { description = "increase the number of master clients", group = "layout" }),
    awful.key({ modkey, "Shift" }, "l", function()
        awful.tag.incnmaster(-1, nil, true)
    end, { description = "decrease the number of master clients", group = "layout" }),

    -- FIX: Find a good keybind for this one

    -- awful.key({ modkey, "Control" }, "h", function()
    --     awful.tag.incncol(1, nil, true)
    -- end, { description = "increase the number of columns", group = "layout" }),
    -- awful.key({ modkey, "Control" }, "l", function()
    --     awful.tag.incncol(-1, nil, true)
    -- end, { description = "decrease the number of columns", group = "layout" }),

    -- Cycle layout
    awful.key({ modkey }, "space", function()
        awful.layout.inc(1)
    end, { description = "select next", group = "layout" }),
    awful.key({ modkey, "Shift" }, "space", function()
        awful.layout.inc(-1)
    end, { description = "select previous", group = "layout" }),

    -- Open a prompt that runs raw Lua code directly against the running
    -- awesome instance — useful for quick debugging/checks (like the
    -- client.focus.floating checks you ran earlier)
    awful.key({ modkey }, "x", function()
        awful.prompt.run({
            prompt = "Run Lua code: ",
            textbox = awful.screen.focused().mypromptbox.widget,
            exe_callback = awful.util.eval,
            history_path = awful.util.get_cache_dir() .. "/history_eval",
        })
    end, { description = "lua execute prompt", group = "awesome" })
)

-- Bind tag numbers (view / toggle / move-to / toggle-on-client), top row 1-9
for i = 1, 5 do
    globalkeys = gears.table.join(
        globalkeys,
        awful.key({ modkey }, "#" .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                tag:view_only()
            end
        end, { description = "view tag #" .. i, group = "tag" }),
        awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:move_to_tag(tag)
                end
            end
        end, { description = "move focused client to tag #" .. i, group = "tag" })
    )
end
