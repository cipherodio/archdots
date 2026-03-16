local awful = require("awful")
local gears = require("gears")
local h = require("utils.helper")
local wibox = require("wibox")

local M = {}

M.wifi_widget = awful.widget.watch(
    "nmcli -t -f active,ssid dev wifi",
    10,
    function(widget, stdout)
        local ssid = stdout:match("yes:(.-)\n")
        widget:set_text(ssid or "Disconnected")
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
                M.ram_widget.text = string.format("%.0f%%", percent)
            end
        end
    end,
})

M.brightness_widget = wibox.widget.textbox()
local function update_bright_widget()
    awful.spawn.easy_async("brightnessctl -m", function(stdout)
        local percentage = stdout:match(",(%d+)%%")
        if percentage then
            M.brightness_widget.text = string.format("%.0f%%", tonumber(percentage))
        else
            M.brightness_widget.text = " ?%"
        end
    end)
end
awesome.connect_signal("brightness_refresh", update_bright_widget)
gears.timer.delayed_call(update_bright_widget)
gears.timer({
    timeout = 30,
    autostart = true,
    callback = update_bright_widget,
})

local vol_container, vol_icon_handle = h.create_vol_icon()
M.vol_icon_widget = vol_container
M.volume_widget = wibox.widget.textbox()
local function update_vol_widget()
    awful.spawn.easy_async("wpctl get-volume @DEFAULT_AUDIO_SINK@", function(stdout)
        local volume_num = stdout:match("(%d%.?%d?%d?)")
        local is_muted = stdout:match("%[MUTED%]")
        local percent = (tonumber(volume_num) or 0) * 100

        if is_muted then
            vol_icon_handle:set_image(h.vol_mute)
        elseif percent < 33 then
            vol_icon_handle:set_image(h.vol_low)
        elseif percent < 66 then
            vol_icon_handle:set_image(h.vol_med)
        else
            vol_icon_handle:set_image(h.vol_high)
        end
        vol_icon_handle.forced_height = 33
        vol_icon_handle.forced_width = 33
        M.volume_widget.text = is_muted and "Muted" or string.format("%.0f%%", percent)
    end)
end
awesome.connect_signal("volume_refresh", update_vol_widget)
gears.timer.delayed_call(update_vol_widget)
gears.timer({
    timeout = 30,
    autostart = true,
    callback = update_vol_widget,
})

local bat_container, bat_icon_handle = h.create_bat_icon()
M.bat_icon_widget = bat_container
M.bat_text_widget = wibox.widget.textbox()

gears.timer({
    timeout = 30,
    call_now = true,
    autostart = true,
    callback = function()
        local path = "/sys/class/power_supply/BAT0/"
        local f_cap = io.open(path .. "capacity", "r")
        local f_sta = io.open(path .. "status", "r")

        if f_cap and f_sta then
            local cap = tonumber(f_cap:read("*all"))
            local sta = f_sta:read("*all"):gsub("\n", "")
            f_cap:close()
            f_sta:close()

            -- Icon Logic
            if sta == "Charging" then
                bat_icon_handle:set_image(h.bat_charging)
            elseif cap < 25 then
                bat_icon_handle:set_image(h.bat_low)
            elseif cap < 80 then
                bat_icon_handle:set_image(h.bat_good)
            else
                bat_icon_handle:set_image(h.bat_full)
            end

            -- Maintain sizing
            bat_icon_handle.forced_height = 33
            bat_icon_handle.forced_width = 33

            M.bat_text_widget.text = string.format("%d%%", cap)
        else
            M.bat_text_widget.text = "?%"
        end
    end,
})

return M
