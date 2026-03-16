local awful = require("awful")
local bindings = require("modules.bindings")
local gears = require("gears")
local h = require("utils.helper")
local wibox = require("wibox")
local widgets = require("utils.widgets")

local M = {}

M.setup = function(s)
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function()
            awful.layout.inc(1)
        end),
        awful.button({}, 3, function()
            awful.layout.inc(-1)
        end)
    ))
    s.mytaglist = awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = bindings.taglist_buttons,
    })
    s.mytasklist = awful.widget.tasklist({
        screen = s,
        filter = awful.widget.tasklist.filter.focused,
        buttons = bindings.tasklist_buttons,
        widget_template = {
            {
                {
                    {
                        {
                            {
                                -- id = "icon_role",
                                image = h.window_icon,
                                widget = wibox.widget.imagebox,
                            },
                            height = 24,
                            width = 24,
                            strategy = "exact",
                            widget = wibox.container.constraint,
                        },
                        valign = "center",
                        widget = wibox.container.place,
                    },
                    {
                        id = "text_role",
                        widget = wibox.widget.textbox,
                    },
                    spacing = 10,
                    layout = wibox.layout.fixed.horizontal,
                },
                left = 10,
                right = 10,
                widget = wibox.container.margin,
            },
            id = "background_role",
            widget = wibox.container.background,
            forced_width = 800,
        },
    })

    -- Create wibar
    s.mywibox = awful.wibar({ position = "top", screen = s, height = 28 })

    -- Widget Layout
    s.mywibox:setup({
        layout = wibox.layout.align.horizontal,
        -- Left widgets
        {
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.textbox(" "),
            s.mylayoutbox,
            h.create_icon(h.clock_icon, 10),
            h.center(wibox.widget.textclock("%I:%M%p")),
            h.create_icon(h.calendar_icon),
            h.center(wibox.widget.textclock("%a %d %b")),
            wibox.widget.textbox(" "),
            s.mytaglist,
            wibox.widget.textbox(" "),
        },
        -- Middle widget
        s.mytasklist,
        -- Right widgets
        {
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.textbox(" "),
            wibox.widget.systray(),
            h.create_icon(h.wifi_icon),
            h.center(widgets.wifi_widget),
            h.create_icon(h.ram_icon),
            h.center(widgets.ram_widget),
            h.create_icon(h.brightness_icon),
            h.center(widgets.brightness_widget),
            widgets.vol_icon_widget,
            h.center(widgets.volume_widget),
            widgets.bat_icon_widget,
            h.center(widgets.bat_text_widget),
            wibox.widget.textbox(" "),
        },
    })
end

return M
