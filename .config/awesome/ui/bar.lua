local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local widgets = require("ui.widget")

local dateblock = widgets.dateblock()
local volumeblock = widgets.volumeblock()
local brightnessblock = widgets.brightnessblock()
local memoryblock = widgets.memoryblock()
local batteryblock = widgets.batteryblock()
local networkblock = widgets.networkblock()
local moonblock = widgets.moonblock()
local forecastblock = widgets.forecastblock()

local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t)
        t:view_only()
    end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t)
        awful.tag.viewnext(t.screen)
    end),
    awful.button({}, 5, function(t)
        awful.tag.viewprev(t.screen)
    end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", { raise = true })
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end)
)

-- No set_wallpaper() here — wallpaper is handled by your own feh script.

awful.screen.connect_for_each_screen(function(s)
    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])

    -- Prompt box (used by modkey+r run prompt)
    s.mypromptbox = awful.widget.prompt()

    -- Layout indicator icon
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function()
            awful.layout.inc(1)
        end),
        awful.button({}, 3, function()
            awful.layout.inc(-1)
        end),
        awful.button({}, 4, function()
            awful.layout.inc(1)
        end),
        awful.button({}, 5, function()
            awful.layout.inc(-1)
        end)
    ))

    s.mytaglist = awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
    })

    s.mytasklist = awful.widget.tasklist({
        screen = s,
        filter = awful.widget.tasklist.filter.focused,
        buttons = tasklist_buttons,
    })

    s.mywibox = awful.wibar({ position = "top", screen = s })

    s.mywibox:setup({
        layout = wibox.layout.align.horizontal,
        { -- Left widgets (no mylauncher — dmenu is the launcher now)
            layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            forecastblock,
            moonblock,
            volumeblock,
            brightnessblock,
            memoryblock,
            networkblock,
            dateblock,
            batteryblock,
            s.mylayoutbox,
        },
    })
end)
