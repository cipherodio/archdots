local awful = require("awful")
local gears = require("gears")
local scratchpad = require("fn.scratchpad")
local widgets = require("ui.widget")

-- Personal scripts / programs, kept separate from stock-derived bindings.
globalkeys = gears.table.join(
    globalkeys,
    -- System
    -- Toggle touchpad
    awful.key({}, "XF86TouchpadToggle", function()
        awful.spawn("padtoggle")
    end, { description = "toggle touchpad", group = "system:script" }),
    -- Audio
    awful.key({}, "XF86AudioRaiseVolume", function()
        awful.spawn.easy_async_with_shell("audiobar +5", function()
            widgets.update_volume()
        end)
    end, { description = "Increase volume", group = "system:script" }),
    awful.key({}, "XF86AudioLowerVolume", function()
        awful.spawn.easy_async_with_shell("audiobar -5", function()
            widgets.update_volume()
        end)
    end, { description = "Decrease volume", group = "system:script" }),
    awful.key({ altkey, "Shift" }, "=", function()
        awful.spawn.easy_async_with_shell("audiobar +5", function()
            widgets.update_volume()
        end)
    end, { description = "Increase volume", group = "system:script" }),
    awful.key({ altkey, "Shift" }, "-", function()
        awful.spawn.easy_async_with_shell("audiobar -5", function()
            widgets.update_volume()
        end)
    end, { description = "Decrease volume", group = "system:script" }),
    awful.key({ altkey, "Shift" }, "0", function()
        awful.spawn.easy_async_with_shell("audiobar toggle", function()
            widgets.update_volume()
        end)
    end, { description = "Toggle mute volume", group = "system:script" }),
    -- Brightness
    awful.key({}, "XF86MonBrightnessUp", function()
        awful.spawn.easy_async_with_shell("brightbar +5", function()
            widgets.update_brightness()
        end)
    end, { description = "Increase brightness", group = "system:script" }),
    awful.key({}, "XF86MonBrightnessDown", function()
        awful.spawn.easy_async_with_shell("brightbar -5", function()
            widgets.update_brightness()
        end)
    end, { description = "Decrease brightness", group = "system:script" }),
    awful.key({ altkey, "Control" }, "=", function()
        awful.spawn.easy_async_with_shell("brightbar +5", function()
            widgets.update_brightness()
        end)
    end, { description = "Increase brightness", group = "system:script" }),
    awful.key({ altkey, "Control" }, "-", function()
        awful.spawn.easy_async_with_shell("brightbar -5", function()
            widgets.update_brightness()
        end)
    end, { description = "Decrease brightness", group = "system:script" }),
    -- Laptop keyboard backlight
    awful.key({ altkey, "Shift" }, "Up", function()
        awful.spawn("backlightkey")
    end, { description = "Toggle laptop keyboard backlight", group = "system:script" }),
    -- Connect bluetooth device
    awful.key({ modkey }, "F2", function()
        awful.spawn("btconnect")
    end, { description = "Connect bluetooth device", group = "system:script" }),
    -- Power menu
    awful.key({ modkey }, "Escape", function()
        awful.spawn("power")
    end, { description = "Power menu via dmenu", group = "script" }),
    -- Slock
    awful.key({ "Control" }, "Escape", function()
        awful.spawn("slock")
    end, { description = "Lock screen", group = "script" }),
    -- Picom toggle
    awful.key({ modkey }, "p", function()
        awful.spawn("picomtoggle")
    end, { description = "Picom toggle via dmenu", group = "script" }),
    -- Usb mount and unmounter
    awful.key({ modkey }, "F9", function()
        awful.spawn("mounter")
    end, { description = "Drive mounter", group = "script" }),
    awful.key({ modkey, "Shift" }, "F9", function()
        awful.spawn("unmounter")
    end, { description = "Drive unmounter", group = "script" }),
    -- Pass menu
    awful.key({ modkey }, "F4", function()
        awful.spawn("passmenu")
    end, { description = "Password manager", group = "script" }),
    -- Screenshot
    awful.key({}, "Print", function()
        awful.spawn("screenshot")
    end, { description = "Screenshot", group = "script" }),
    awful.key({ modkey }, "Print", function()
        awful.spawn("timeshot")
    end, { description = "Screenshot with timer", group = "script" }),
    -- Camera
    awful.key({ modkey }, "c", function()
        awful.spawn("camtoggle")
    end, { description = "Open camera", group = "script" }),
    -- Video recording
    awful.key({ modkey }, "F8", function()
        awful.spawn("screencast")
    end, { description = "Video recording", group = "script" }),
    -- Clutter
    awful.key({ modkey, "Shift" }, "c", function()
        awful.spawn("cluttertoggle")
    end, { description = "Toggles clutter", group = "script" }),
    -- Clutter and picom toggle for better gaming performance
    awful.key({ modkey }, "g", function()
        awful.spawn("gameon")
    end, { description = "Toggle both picom and clutter", group = "script" }),
    -- Web bookmarks
    awful.key({ modkey }, "w", function()
        awful.spawn("bookmarklink")
    end, { description = "Open bookmark via dmenu", group = "script" }),
    -- Emojis
    awful.key({ modkey }, "`", function()
        awful.spawn("emojis")
    end, { description = "Emojis via dmenu", group = "script" }),
    -- Torrent
    awful.key({ modkey }, "F12", function()
        awful.spawn("torrtoggle")
    end, { description = "Torrent daemon toggle", group = "script" }),
    awful.key({ modkey, "Shift" }, "F12", function()
        awful.spawn("torrclear")
    end, { description = "Clear completed torrent downloads", group = "script" }),
    -- Spotify
    awful.key({ modkey }, "s", function()
        awful.spawn("spotify-toggle")
    end, { description = "Play and pause toggle for spotify", group = "script" }),
    awful.key({ modkey }, ".", function()
        awful.spawn("spotify-next")
    end, { description = "Next track spotify", group = "script" }),
    awful.key({ modkey }, ",", function()
        awful.spawn("spotify-prev")
    end, { description = "Previous track spotify", group = "script" }),
    -- Mpc
    awful.key({ modkey, "Shift" }, "p", function()
        awful.spawn("mpc toggle")
    end, { description = "Play and pause toggle for mpc", group = "mpc" }),
    awful.key({ modkey, "Shift" }, ".", function()
        awful.spawn("mpc next")
    end, { description = "Next track mpc", group = "mpc" }),
    awful.key({ modkey, "Shift" }, ",", function()
        awful.spawn("mpc prev")
    end, { description = "Previous track mpc", group = "mpc" }),
    awful.key({ modkey, "Shift" }, "s", function()
        awful.spawn("mpcplaylist")
    end, { description = "Song playlist for mpc via dmenu", group = "script" }),
    -- Browser
    awful.key({ modkey }, "b", function()
        awful.spawn(browser)
    end, { description = "Firefox browser", group = "browser" }),
    -- Lf file manager with image previewer
    awful.key({ modkey }, "o", function()
        awful.spawn(terminal .. " -e lfprev")
    end, { description = "Lf file manager", group = "file manager" }),
    -- Emacs
    awful.key({ modkey }, "e", function()
        awful.spawn(emacscmd)
    end, { description = "Emacs", group = "editor" }),
    awful.key({ modkey }, "F1", function()
        awful.spawn("ekill")
    end, { description = "Toggle Emacs daemon", group = "script" }),
    -- TEMPORARY BINDING
    awful.key({ modkey, "Shift" }, "b", function()
        awful.spawn.easy_async_with_shell(
            "notify-send 'blender state' 'floating="
                .. tostring(client.focus and client.focus.floating)
                .. " fullscreen="
                .. tostring(client.focus and client.focus.fullscreen)
                .. " maximized="
                .. tostring(client.focus and client.focus.maximized)
                .. "'",
            function() end
        )
    end),
    awful.key({ modkey, "Shift" }, "t", function()
        awful.spawn.easy_async_with_shell(
            "echo TERM=$TERMINAL > /tmp/termcheck.txt",
            function() end
        )
    end, { description = "check TERMINAL env (temp)", group = "script" }),
    -- Scratchpads
    awful.key({ modkey, "Shift" }, "Return", function()
        scratchpad.toggle("spterm")
    end, { description = "toggle scratchpad: terminal", group = "scratchpad" }),
    awful.key({ altkey, "Shift" }, "p", function()
        scratchpad.toggle("sppulse")
    end, { description = "toggle scratchpad: pulsemixer", group = "scratchpad" }),
    awful.key({ altkey, "Shift" }, "n", function()
        scratchpad.toggle("spnews")
    end, { description = "toggle scratchpad: newsboat", group = "scratchpad" }),
    awful.key({ altkey, "Shift" }, "m", function()
        scratchpad.toggle("spmusic")
    end, { description = "toggle scratchpad: ncmpcpp", group = "scratchpad" }),
    awful.key({ altkey, "Shift" }, "h", function()
        scratchpad.toggle("sphtop")
    end, { description = "toggle scratchpad: htop", group = "scratchpad" }),
    awful.key({ altkey, "Shift" }, "l", function()
        scratchpad.toggle("sptask")
    end, { description = "toggle scratchpad: taskwarrior-tui", group = "scratchpad" })
)
