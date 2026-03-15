local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local M = {}

M.wifi_widget = awful.widget.watch(
    "nmcli -t -f active,ssid dev wifi",
    10,
    function(widget, stdout)
        local ssid = stdout:match("yes:(.-)\n")
        widget:set_text(ssid and (" 󰖩 " .. ssid) or " 󰖪 Disconnected")
    end
)

M.ram_widget = wibox.widget.textbox()
gears.timer({
    timeout = 5,
    call_now = true,
    autostart = true,
    callback = function()
        local f = io.open("/proc/meminfo", "r")
        if f then
            local content = f:read("*all")
            f:close()
            local total = tonumber(content:match("MemTotal:%s+(%d+)"))
            local avail = tonumber(content:match("MemAvailable:%s+(%d+)"))
            if total and avail then
                local used = total - avail
                local percent = (used / total) * 100
                M.ram_widget.text = string.format(" %.0f%%", percent)
            end
        end
    end,
})

M.brightness_widget = wibox.widget.textbox()
gears.timer({
    timeout = 10,
    autostart = true,
    callback = function()
        local path = "/sys/class/backlight/amdgpu_bl2/"
        local f_max = io.open(path .. "max_brightness", "r")
        local f_cur = io.open(path .. "brightness", "r")
        if f_max and f_cur then
            local max = tonumber(f_max:read("*all"))
            local cur = tonumber(f_cur:read("*all"))
            f_max:close()
            f_cur:close()
            if max and cur then
                M.brightness_widget.text = string.format("󰃟 %.0f%%", (cur / max) * 100)
            end
        else
            if f_max then
                f_max:close()
            end
            if f_cur then
                f_cur:close()
            end
            M.brightness_widget.text = " ?%"
        end
    end,
})

M.volume_widget = wibox.widget.textbox()
local function update_vol_widget()
    awful.spawn.easy_async("wpctl get-volume @DEFAULT_AUDIO_SINK@", function(stdout)
        local volume_num = stdout:match("(%d%.%d%d)")
        local is_muted = stdout:match("%[MUTED%]")
        if is_muted then
            M.volume_widget.text = "   Muted"
        elseif volume_num then
            local percent = tonumber(volume_num) * 100
            M.volume_widget.text = string.format("󰕾 %.0f%%", percent)
        else
            M.volume_widget.text = " ?%"
        end
    end)
end
awesome.connect_signal("volume_refresh", update_vol_widget)
gears.timer.delayed_call(update_vol_widget)
gears.timer({
    timeout = 30,
    autostart = true,
    callback = update_vol_widget,
})

M.bat_widget = wibox.widget.textbox()
gears.timer({
    timeout = 30,
    call_now = true,
    autostart = true,
    callback = function()
        local path = "/sys/class/power_supply/BAT0/"
        local f_cap = io.open(path .. "capacity", "r")
        local f_sta = io.open(path .. "status", "r")

        if f_cap and f_sta then
            local cap_str = f_cap:read("*all"):gsub("\n", "")
            local sta = f_sta:read("*all"):gsub("\n", "")
            f_cap:close()
            f_sta:close()
            local cap = tonumber(cap_str)
            local icon = (sta == "Charging") and "󱐋 " or " "
            M.bat_widget.text = string.format("%s%d%%", icon, cap)
        else
            M.bat_widget.text = "?%"
        end
    end,
})

return M
