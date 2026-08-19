local awful = require("awful")

-- Check if awesome fell back to a default config due to a startup error.
if awesome.startup_errors then
    awful.spawn.with_shell(
        "notify-send -u critical 'awesome' 'Errors during startup — check config'"
    )
end

-- Handle runtime errors after startup (no naughty — routed through
-- notify-send, which dunst intercepts).
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        local msg = tostring(err):gsub("'", "'\\''")
        awful.spawn.with_shell("notify-send -u critical 'awesome error' '" .. msg .. "'")

        in_error = false
    end)
end
