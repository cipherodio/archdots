local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local M = {}

-- WiFi SSID Widget | Updates every 10s
M.wifi_widget = wibox.widget.textbox()
gears.timer({
	timeout = 10,
	call_now = true,
	autostart = true,
	callback = function()
		awful.spawn.easy_async_with_shell(
			"nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2",
			function(stdout)
				local ssid = stdout:gsub("\n", "")
				if ssid == "" then
					M.wifi_widget.text = " 󰖪 Disconnected"
				else
					M.wifi_widget.text = " 󰖩 " .. ssid
				end
			end
		)
	end,
})

-- RAM Percentage Widget | Updates every 5s
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

-- Brightness Widget | Updates every 10s
M.brightness_widget = wibox.widget.textbox()
gears.timer({
	timeout = 10,
	call_now = true,
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
				local percent = (cur / max) * 100
				M.brightness_widget.text = string.format("󰃟 %.0f%%", percent)
			end
		else
			M.brightness_widget.text = " ?%"
		end
	end,
})

-- Volume Widget | Updates every 0.1s
M.volume_widget = awful.widget.watch("wpctl get-volume @DEFAULT_AUDIO_SINK@", 0.1, function(widget, stdout)
	local volume_num = stdout:match("(%d%.%d%d)")
	local is_muted = stdout:match("%[MUTED%]")

	if is_muted then
		widget:set_text("   Muted")
	elseif volume_num then
		local percent = tonumber(volume_num) * 100
		widget:set_text(string.format("󰕾 %.0f%%", percent))
	else
		widget:set_text(" ?%")
	end
end)

-- Battery Widget | Updates every 30s
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
