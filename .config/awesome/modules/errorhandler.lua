local awful = require("awful")

-- Startup error handling
if awesome.startup_errors then
	awful.spawn.with_shell(
		string.format('notify-send -u critical "AwesomeWM Startup Error" "%s"', awesome.startup_errors:gsub('"', '\\"'))
	)
end

-- Runtime error handling at startup
local in_error = false
awesome.connect_signal("debug::error", function(err)
	if in_error then
		return
	end
	in_error = true

	awful.spawn.with_shell(
		string.format('notify-send -u critical "AwesomeWM Runtime Error" "%s"', tostring(err):gsub('"', '\\"'))
	)
	in_error = false
end)
