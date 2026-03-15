local awful = require("awful")
local bindings = require("modules.bindings")
local gears = require("gears")
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
                                id = "icon_role",
                                widget = wibox.widget.imagebox,
                            },
                            height = 20,
                            width = 20,
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
            wibox.widget.textbox(" 󱑂 "),
            -- wibox.widget.textclock("%I:%M %p %a %d %b"),
            wibox.widget.textclock("%I:%M %p"),
            wibox.widget.textbox("  "),
            wibox.widget.textclock("%a %d %b"),
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
            widgets.wifi_widget,
            wibox.widget.textbox(" "),
            widgets.ram_widget,
            wibox.widget.textbox(" "),
            widgets.brightness_widget,
            wibox.widget.textbox(" "),
            widgets.volume_widget,
            wibox.widget.textbox(" "),
            widgets.bat_widget,
            wibox.widget.textbox(" "),
        },
    })
end

return M
