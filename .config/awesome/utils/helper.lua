local gears = require("gears")
local wibox = require("wibox")
local xdg_config_dir = gears.filesystem.get_xdg_config_home()

local M = {}

M.assets = xdg_config_dir .. "assets/onedark"
M.clock_icon = M.assets .. "/icons/clock.png"
M.calendar_icon = M.assets .. "/icons/calendar.png"
M.wifi_icon = M.assets .. "/icons/wifi.png"
M.ram_icon = M.assets .. "/icons/ram.png"
M.brightness_icon = M.assets .. "/icons/brightness.png"
M.window_icon = M.assets .. "/icons/window.png"
M.vol_mute = M.assets .. "/volume/audio-volume-muted.png"
M.vol_low = M.assets .. "/volume/audio-volume-low.png"
M.vol_med = M.assets .. "/volume/audio-volume-medium.png"
M.vol_high = M.assets .. "/volume/audio-volume-high.png"
M.bat_charging = M.assets .. "/battery/battery-full-charging.png"
M.bat_full = M.assets .. "/battery/battery-full.png"
M.bat_good = M.assets .. "/battery/battery-good.png"
M.bat_low = M.assets .. "/battery/battery-low.png"

-- Helper function to wrap icons in a container
function M.create_icon(path, left_margin, right_margin)
    return wibox.widget({
        {
            {
                image = path,
                resize = true,
                widget = wibox.widget.imagebox,
            },
            valign = "center",
            widget = wibox.container.place,
        },
        top = 4,
        bottom = 4,
        left = left_margin or 20,
        right = right_margin or 4,
        widget = wibox.container.margin,
    })
end

function M.create_vol_icon()
    local icon_handle = wibox.widget({
        resize = true,
        forced_height = 33,
        forced_width = 33,
        widget = wibox.widget.imagebox,
    })
    local container = wibox.widget({
        {
            icon_handle,
            top = -5,
            bottom = -5,
            left = 10,
            right = -2,
            widget = wibox.container.margin,
        },
        valign = "center",
        widget = wibox.container.place,
    })
    return container, icon_handle
end

function M.create_bat_icon()
    local icon_handle = wibox.widget({
        resize = true,
        forced_height = 33,
        forced_width = 33,
        widget = wibox.widget.imagebox,
    })
    local container = wibox.widget({
        {
            icon_handle,
            top = -5,
            bottom = -5,
            left = 10,
            right = -2,
            widget = wibox.container.margin,
        },
        valign = "center",
        widget = wibox.container.place,
    })
    return container, icon_handle
end

function M.center(widget)
    return wibox.widget({
        widget,
        valign = "center",
        widget = wibox.container.place,
    })
end

return M
