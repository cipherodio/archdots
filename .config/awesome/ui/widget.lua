local awful = require("awful")
local gears = require("gears")
local status = require("fn.status")
local wibox = require("wibox")

local M = {}

-- ===== Date/time block (native Lua, no external script) =====

local function clock_icon(hour)
    local icons = {
        "🕛",
        "🕐",
        "🕑",
        "🕒",
        "🕓",
        "🕔",
        "🕕",
        "🕖",
        "🕗",
        "🕘",
        "🕙",
        "🕚",
    }
    return icons[(hour % 12) + 1]
end

function M.dateblock()
    local widget = wibox.widget.textbox()

    local function update()
        local hour = tonumber(os.date("%H"))
        local icon = clock_icon(hour)
        widget:set_text(os.date("📅%a-%d-%b ") .. icon .. os.date("%I:%M%p"))
    end

    update()
    gears.timer({
        timeout = 60,
        autostart = true,
        call_now = true,
        callback = update,
    })

    widget:buttons(gears.table.join(
        awful.button({}, 1, function()
            awful.spawn.with_shell(
                "notify-send \"This Month\" \"$(cal | sed \"s/\\<$(date '+%e' | tr -d ' ')\\>/<b><span color='red'>&<\\/span><\\/b>/\")\" && "
                    .. 'notify-send "Appointments" "$(calcurse -d3)"'
            )
        end),
        awful.button({}, 2, function()
            awful.spawn.with_shell(
                "notify-send '📅 Time/date module\n- Left: calendar\n- Right: calcurse'"
            )
        end),
        awful.button({}, 3, function()
            awful.spawn.with_shell(terminal .. " -e calcurse")
        end)
    ))

    return widget
end

-- ===== Volume block =====

function M.volumeblock()
    local widget = wibox.widget.textbox()

    local function refresh()
        status.volume(function(text)
            widget:set_text(text)
        end)
    end

    refresh()
    M.update_volume = refresh -- exposed for external keybinds (userkeys.lua)

    widget:buttons(gears.table.join(
        awful.button({}, 1, function()
            awful.spawn(terminal .. " -e pulsemixer")
            refresh()
        end),
        awful.button({}, 2, function()
            awful.spawn.with_shell(
                "notify-send '📢 Volume module\n- Left: mixer\n- Scroll: vol\n- Right: mute'"
            )
        end),
        awful.button({}, 3, function()
            awful.spawn.easy_async_with_shell("audiobar toggle", refresh)
        end),
        awful.button({}, 4, function()
            awful.spawn.easy_async_with_shell("audiobar +5", refresh)
        end),
        awful.button({}, 5, function()
            awful.spawn.easy_async_with_shell("audiobar -5", refresh)
        end)
    ))

    return widget
end

-- ===== Brightness block =====

function M.brightnessblock()
    local widget = wibox.widget.textbox()

    local function refresh()
        status.brightness(function(text)
            widget:set_text(text)
        end)
    end

    refresh()
    M.update_brightness = refresh -- exposed for external keybinds (userkeys.lua)

    widget:buttons(gears.table.join(
        awful.button({}, 2, function()
            awful.spawn.with_shell(
                "notify-send '💡 Brightness module\n- Scroll: adjust brightness.'"
            )
        end),
        awful.button({}, 4, function()
            awful.spawn.easy_async_with_shell("brightbar +5", refresh)
        end),
        awful.button({}, 5, function()
            awful.spawn.easy_async_with_shell("brightbar -5", refresh)
        end)
    ))

    return widget
end

-- ===== Memory block =====

function M.memoryblock()
    local widget = wibox.widget.textbox()

    local function refresh()
        local text = status.memory()
        if text then
            widget:set_text(text)
        end
    end

    refresh()
    gears.timer({
        timeout = 10,
        autostart = true,
        call_now = false,
        callback = refresh,
    })

    widget:buttons(gears.table.join(
        awful.button({}, 1, function()
            awful.spawn.with_shell(
                "notify-send '🧠 Memory hogs' \"$(ps axch -o cmd,%mem | "
                    .. "awk '{cmd[$1]+=$2} END {for (i in cmd) print i, cmd[i]}' | "
                    .. 'sort -nrk2 | head)"'
            )
        end),
        awful.button({}, 2, function()
            awful.spawn.with_shell(
                "notify-send '🧠 Memory module\n- Left click: memory hogs\n- Right click: htop'"
            )
        end),
        awful.button({}, 3, function()
            awful.spawn(terminal .. " -e htop")
        end)
    ))

    return widget
end

-- ===== Battery block =====

function M.batteryblock()
    local widget = wibox.widget.textbox()

    local function refresh()
        status.battery(function(text)
            widget:set_text(text)
        end)
    end

    refresh()
    gears.timer({
        timeout = 5,
        autostart = true,
        call_now = false,
        callback = refresh,
    })

    widget:buttons(gears.table.join(awful.button({}, 2, function()
        awful.spawn.with_shell(
            "notify-send '🔋 Battery module\n"
                .. "🔋: discharging\n🟠: not charging\n♻: stagnant charge\n"
                .. "🔌: charging\n⚡: charged\n❗: battery very low!'"
        )
    end)))

    return widget
end

-- ===== Network block =====

function M.networkblock()
    local widget = wibox.widget.textbox()

    local function refresh()
        status.network(function(text)
            widget:set_text(text)
        end)
    end

    refresh()
    gears.timer({
        timeout = 5,
        autostart = true,
        call_now = false,
        callback = refresh,
    })

    widget:buttons(gears.table.join(
        awful.button({}, 1, function()
            awful.spawn("ssidnotify")
        end),
        awful.button({}, 2, function()
            awful.spawn.with_shell(
                "notify-send '🌐 Internet module\n- Left: connect\n- Right: show SSID\n"
                    .. "❌: wifi disabled\n📡: no wifi\n📶: wifi quality\n❎: no ethernet\n🌐: ethernet'"
            )
        end),
        awful.button({}, 3, function()
            awful.spawn(terminal .. " -e nmtui")
        end)
    ))

    return widget
end

-- ===== Moon phase block =====

function M.moonblock()
    local widget = wibox.widget.textbox()

    local function refresh()
        status.moon(function(text)
            widget:set_text(text)
        end)
    end

    refresh()
    gears.timer({
        timeout = 21600, -- 6 hours
        autostart = true,
        call_now = false,
        callback = refresh,
    })

    widget:buttons(gears.table.join(awful.button({}, 1, function()
        awful.spawn.with_shell(
            'notify-send "🌜 $(sed -n \'2p\' "$HOME/.cache/moonphase")"'
        )
    end)))

    return widget
end

-- ===== Weather forecast block =====

function M.forecastblock()
    local widget = wibox.widget.textbox()

    local function refresh()
        status.forecast(function(text)
            widget:set_text(text)
        end)
    end

    refresh()
    gears.timer({
        timeout = 3600, -- 1 hour
        autostart = true,
        call_now = false,
        callback = refresh,
    })

    widget:buttons(gears.table.join(awful.button({}, 3, function()
        awful.spawn(
            terminal .. " -e less -Sf " .. os.getenv("HOME") .. "/.cache/weatherreport"
        )
    end)))

    return widget
end

return M
