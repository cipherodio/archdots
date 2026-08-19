local awful = require("awful")

local M = {}

-- Reads current volume state via wpctl and passes a formatted display
-- string to `callback`. Doesn't touch any widget directly — the caller
-- decides what to do with the text.
function M.volume(callback)
    awful.spawn.easy_async_with_shell(
        "wpctl get-volume @DEFAULT_AUDIO_SINK@",
        function(stdout)
            local text
            if stdout:find("%[MUTED%]") then
                text = "🔇"
            else
                local vol = tonumber(stdout:match("([0-9.]+)"))
                if vol then
                    vol = math.floor(vol * 100)
                    if vol >= 70 then
                        text = "🔊" .. vol .. "%"
                    elseif vol >= 30 then
                        text = "🔉" .. vol .. "%"
                    elseif vol >= 1 then
                        text = "🔈" .. vol .. "%"
                    else
                        text = "🔇"
                    end
                end
            end
            if text then
                callback(text)
            end
        end
    )
end

-- Reads current backlight brightness via sysfs and passes a formatted
-- display string to `callback`.
function M.brightness(callback)
    local cmd = [[
for path in /sys/class/backlight/*; do
    [ -e "$path" ] || continue
    backlight_dir=$path
    break
done
[ -n "${backlight_dir:-}" ] || exit 1
read -r curr <"$backlight_dir/brightness"
read -r max <"$backlight_dir/max_brightness"
[ "$max" -gt 0 ] 2>/dev/null || exit 1
printf '%d\n' $(( (curr * 100 + max / 2) / max ))
]]
    awful.spawn.easy_async_with_shell(cmd, function(stdout)
        local pct = tonumber(stdout:match("%d+"))
        if pct then
            callback("💡" .. pct .. "%")
        end
    end)
end

-- Reads current memory usage percentage directly from /proc/meminfo
-- (no shell spawn needed — plain file read). Returns nil if unreadable.
function M.memory()
    local f = io.open("/proc/meminfo", "r")
    if not f then
        return nil
    end

    local total, available
    for line in f:lines() do
        local t = line:match("^MemTotal:%s+(%d+)")
        if t then
            total = tonumber(t)
        end
        local a = line:match("^MemAvailable:%s+(%d+)")
        if a then
            available = tonumber(a)
        end
        if total and available then
            break
        end
    end
    f:close()

    if not total or not available or total <= 0 then
        return nil
    end

    local pct = math.floor((total - available) * 100 / total)
    return "🧠" .. pct .. "%"
end

-- Reads battery status/capacity for every BAT* device and passes a
-- formatted display string to `callback`. Handles multiple batteries.
function M.battery(callback)
    local cmd = [[
output=""
for battery in /sys/class/power_supply/BAT?*; do
    [ -e "$battery" ] || continue
    if [ -n "$output" ]; then
        output="$output "
    fi
    read -r raw_status <"$battery/status"
    read -r capacity <"$battery/capacity"
    case "$raw_status" in
    Full) bat_icon="⚡" ;;
    Discharging) bat_icon="🔋" ;;
    Charging) bat_icon="🔌" ;;
    "Not charging") bat_icon="🟠" ;;
    Unknown) bat_icon="♻️" ;;
    *) bat_icon="?" ;;
    esac
    warn=""
    if [ "$bat_icon" = "🔋" ] && [ "$capacity" -le 25 ] 2>/dev/null; then
        warn="❗"
    fi
    output="${output}${bat_icon}${warn}${capacity}%"
done
printf '%s\n' "$output"
]]
    awful.spawn.easy_async_with_shell(cmd, function(stdout)
        local text = stdout:gsub("\n$", "")
        if text ~= "" then
            callback(text)
        end
    end)
end

-- Reads wifi/ethernet connection state and passes a formatted display
-- string to `callback`.
function M.network(callback)
    local cmd = [[
wifiicon=""
ethericon=""
for dev in /sys/class/net/w*; do
    [ -e "$dev" ] || continue
    read -r operstate <"$dev/operstate" 2>/dev/null
    if [ "$operstate" = "up" ]; then
        quality=$(awk -v dev="$(basename "$dev")" '
            $1 ~ dev ":" { print int($3) }
        ' /proc/net/wireless)
        if [ -n "$quality" ] && [ "$quality" -gt 0 ] 2>/dev/null; then
            percent=$((quality * 100 / 70))
            wifiicon="📶${percent}%"
        else
            wifiicon="📶"
        fi
    elif [ "$operstate" = "down" ]; then
        read -r flags <"$dev/flags" 2>/dev/null
        if [ "$flags" = "0x1003" ]; then
            wifiicon="📡"
        else
            wifiicon="❌"
        fi
    fi
done
for dev in /sys/class/net/e*; do
    [ -e "$dev" ] || continue
    read -r operstate <"$dev/operstate" 2>/dev/null
    if [ "$operstate" = "up" ]; then
        ethericon="🌐"
    elif [ -z "$wifiicon" ] || [ "$wifiicon" = "❌" ]; then
        ethericon="❎"
    fi
done
printf '%s%s\n' "$wifiicon" "$ethericon"
]]
    awful.spawn.easy_async_with_shell(cmd, function(stdout)
        local text = stdout:gsub("\n$", "")
        if text ~= "" then
            callback(text)
        end
    end)
end

-- Fetches current moon phase (cached, refreshed periodically) and passes
-- a formatted display string to `callback`.
function M.moon(callback)
    local cmd = [[
cache="$HOME/.cache/moonphase"
if json=$(curl -sf "wttr.in/$LOCATION?format=j1"); then
    phase=$(printf '%s' "$json" | jq -r '
        .weather[0].astronomy[0].moon_phase
    ')
    case "$phase" in
    "New Moon") moon="🌑" ;;
    "Waxing Crescent") moon="🌒" ;;
    "First Quarter") moon="🌓" ;;
    "Waxing Gibbous") moon="🌔" ;;
    "Full Moon") moon="🌕" ;;
    "Waning Gibbous") moon="🌖" ;;
    "Last Quarter") moon="🌗" ;;
    "Waning Crescent") moon="🌘" ;;
    *) moon="🌜" ;;
    esac
    printf '%s\n%s\n' "$moon" "$phase" >"$cache"
fi
[ -r "$cache" ] && sed -n '1p' "$cache"
]]
    awful.spawn.easy_async_with_shell(cmd, function(stdout)
        local text = stdout:gsub("\n$", "")
        if text ~= "" then
            callback(text)
        end
    end)
end

-- Fetches current weather conditions (cached, refreshed periodically)
-- and passes a formatted display string to `callback`.
function M.forecast(callback)
    local cmd = [[
cache="$HOME/.cache/weatherstatus"
weatherreport="$HOME/.cache/weatherreport"
if json=$(curl -sf "wttr.in/$LOCATION?format=j1"); then
    weather=$(printf '%s' "$json" | jq -r '
        .current_condition[0] as $c
        | .weather[0].hourly[0] as $h
        | "🌞+\($c.temp_C)(\($c.FeelsLikeC))°C 🍃\($c.winddir16Point) \($c.windspeedKmph) km/h ☔\($h.chanceofrain)%"
    ') || exit 1
    printf ' %s\n' "$weather" >"$cache"
    curl -sf "wttr.in/$LOCATION" >"$weatherreport"
fi
[ -r "$cache" ] && cat "$cache"
]]
    awful.spawn.easy_async_with_shell(cmd, function(stdout)
        local text = stdout:gsub("\n$", "")
        if text ~= "" then
            callback(text)
        end
    end)
end

return M
