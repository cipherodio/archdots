local gears = require("gears")
local awful = require("awful")

local env = require("modules.uservar")

local M = {}

-- Key bindings
M.globalkeys = gears.table.join(
	-- Navigation
	awful.key({ env.modkey }, "h", function()
		awful.client.focus.bydirection("left")
	end, { description = "focus left" }),
	awful.key({ env.modkey }, "l", function()
		awful.client.focus.bydirection("right")
	end, { description = "focus right" }),
	awful.key({ env.modkey }, "j", function()
		awful.client.focus.bydirection("down")
	end, { description = "focus down" }),
	awful.key({ env.modkey }, "k", function()
		awful.client.focus.bydirection("up")
	end, { description = "focus up" }),
	awful.key({ env.modkey }, "Tab", function()
		awful.tag.history.restore()
	end, { description = "switch last view" }),
	-- Layouts
	awful.key({ env.modkey, "Control" }, "space", function()
		awful.layout.set(awful.layout.suit.tile)
	end, { description = "reset layout" }),
	awful.key({ env.modkey }, "i", function()
		awful.layout.inc(1)
	end, { description = "next layout" }), --X
	-- Shuffle window
	awful.key({ env.modkey, "Shift" }, "j", function()
		awful.client.swap.byidx(1)
	end, { description = "swap with next client by index", group = "client" }),
	awful.key({ env.modkey, "Shift" }, "k", function()
		awful.client.swap.byidx(-1)
	end, { description = "swap with previous client by index", group = "client" }),
	awful.key({ env.modkey, "Shift" }, "l", function()
		awful.tag.incnmaster(-1, nil, true)
	end, { description = "decrease the number of master clients", group = "layout" }),
	awful.key({ env.modkey, "Shift" }, "h", function()
		awful.tag.incnmaster(1, nil, true)
	end, { description = "increase the number of master clients", group = "layout" }),
	-- Adjust window
	awful.key({ env.altkey, "Shift" }, "l", function()
		awful.tag.incmwfact(0.05)
	end, { description = "grow right" }),
	awful.key({ env.altkey, "Shift" }, "h", function()
		awful.tag.incmwfact(-0.05)
	end, { description = "grow left" }),
	awful.key({ env.altkey, "Shift" }, "j", function()
		awful.client.incwfact(-0.05)
	end, { description = "grow down" }),
	awful.key({ env.altkey, "Shift" }, "k", function()
		awful.client.incwfact(0.05)
	end, { description = "grow up" }),
	-- System
	awful.key({ env.modkey, "Control" }, "r", awesome.restart, { description = "reload awesome" }),
	awful.key({ env.modkey, "Control" }, "x", awesome.quit, { description = "shutdown" }),
	awful.key({ env.modkey }, "Escape", function()
		awful.spawn.with_shell("power")
	end, { description = "power menu" }),
	awful.key({}, "XF86MonBrightnessUp", function()
		awful.spawn.with_shell("brightnessctl set +5%")
	end, { description = "bright up" }),
	awful.key({}, "XF86MonBrightnessDown", function()
		awful.spawn.with_shell("brightnessctl set 5%-")
	end, { description = "bright down" }),
	awful.key({}, "XF86TouchpadToggle", function()
		awful.spawn.with_shell("padtoggle")
	end, { description = "touchpad" }),
	awful.key({ env.altkey }, "b", function()
		for s in screen do
			s.mywibox.visible = not s.mywibox.visible
		end
	end, { description = "toggle bar" }),
	awful.key({ env.modkey }, "F2", function()
		awful.spawn.with_shell("podconnect")
	end, { description = "airpods" }),
	awful.key({ env.modkey }, "F4", function()
		awful.spawn.with_shell("rofipassmenu")
	end, { description = "pass" }),
	awful.key({ env.modkey }, "F8", function()
		awful.spawn.with_shell("screencast")
	end, { description = "record" }),
	awful.key({ env.modkey }, "F9", function()
		awful.spawn.with_shell("mounter")
	end, { description = "mount" }),
	awful.key({ env.modkey, "Shift" }, "F9", function()
		awful.spawn.with_shell("unmounter")
	end, { description = "unmount" }),
	awful.key({ env.modkey }, "p", function()
		awful.spawn.with_shell("picomtoggle")
	end, { description = "picom" }),
	awful.key({ env.modkey }, "g", function()
		awful.spawn.with_shell("gameon")
	end, { description = "game mode" }),
	awful.key({ env.modkey, "Shift" }, "c", function()
		awful.spawn.with_shell("cluttertoggle")
	end, { description = "unclutter" }),
	-- Media
	awful.key({ env.altkey, "Shift" }, "equal", function()
		awful.spawn("audiobar 0 +5")
	end, { description = "Volume up with dunst notification" }),
	awful.key({ env.altkey, "Shift" }, "minus", function()
		awful.spawn("audiobar 0 -5")
	end, { description = "Volume down with dunst notification" }),
	awful.key({}, "XF86AudioMute", function()
		awful.spawn.with_shell("pactl set-sink-mute @DEFAULT_SINK@ toggle")
	end, { description = "mute" }),
	awful.key({}, "XF86AudioRaiseVolume", function()
		awful.spawn.with_shell("audiobar 0 +5")
	end, { description = "volume up" }),
	awful.key({}, "XF86AudioLowerVolume", function()
		awful.spawn.with_shell("audiobar 0 -5")
	end, { description = "volume down" }),
	awful.key({ env.modkey }, "s", function()
		awful.spawn.with_shell("spotify-toggle")
	end, { description = "spotify toggle" }),
	awful.key({ env.modkey }, "period", function()
		awful.spawn.with_shell("spotify-next")
	end, { description = "spotify next" }),
	awful.key({ env.modkey }, "comma", function()
		awful.spawn.with_shell("spotify-prev")
	end, { description = "spotify prev" }),
	awful.key({ env.modkey, "Shift" }, "s", function()
		awful.spawn.with_shell("mpcplaylist")
	end, { description = "mpc search" }),
	awful.key({ env.modkey, "Shift" }, "p", function()
		awful.spawn.with_shell("mpc toggle")
	end, { description = "mpc toggle" }),
	awful.key({ env.modkey, "Shift" }, "period", function()
		awful.spawn.with_shell("mpc next")
	end, { description = "mpc next" }),
	awful.key({ env.modkey, "Shift" }, "comma", function()
		awful.spawn.with_shell("mpc prev")
	end, { description = "mpc prev" }),
	awful.key({ env.modkey }, "c", function()
		awful.spawn.with_shell("camtoggle")
	end, { description = "webcam" }),
	-- Program & Launchers
	awful.key({ env.modkey }, "Return", function()
		awful.spawn(env.terminal)
	end, { description = "terminal" }),
	awful.key({ env.modkey }, "d", function()
		awful.spawn.with_shell(env.rofi_cmd)
	end, { description = "rofi" }),
	awful.key({ env.modkey }, "b", function()
		awful.spawn("firefox")
	end, { description = "browser" }),
	awful.key({ env.modkey, "Shift" }, "b", function()
		awful.spawn("qutebrowser")
	end, { description = "qutebrowser" }),
	awful.key({ env.modkey }, "o", function()
		awful.spawn(env.terminal .. " -e lf")
	end, { description = "file manager" }),
	awful.key({ env.modkey }, "e", function()
		awful.spawn("emacsclient -c -a 'emacs'")
	end, { description = "emacs" }),
	awful.key({ env.modkey }, "F1", function()
		awful.spawn.with_shell("ekill")
	end, { description = "emacs daemon toggle" }),
	awful.key({ env.modkey }, "F12", function()
		awful.spawn.with_shell("torrtoggle")
	end, { description = "torrent" }),
	awful.key({ env.modkey, "Shift" }, "F12", function()
		awful.spawn.with_shell("torrclear")
	end, { description = "torrent clear" }),
	awful.key({ env.modkey }, "grave", function()
		awful.spawn.with_shell("emojis")
	end, { description = "emojis" }),
	awful.key({}, "Print", function()
		awful.spawn.with_shell("screenshot")
	end, { description = "screenshot" }),
	awful.key({ env.modkey }, "Print", function()
		awful.spawn.with_shell("timeshot")
	end, { description = "timed screenshot" }),
	awful.key({ env.modkey }, "w", function()
		awful.spawn.with_shell("bookmarklink")
	end, { description = "web search" }),
	-- Misc
	awful.key({ env.modkey }, "u", awful.client.urgent.jumpto, { description = "jump to urgent client" })
)

M.clientkeys = gears.table.join(
	awful.key({ env.modkey }, "q", function(c)
		c:kill()
	end, { description = "close" }),
	awful.key({ env.modkey }, "f", function(c)
		c.fullscreen = not c.fullscreen
		c:raise()
	end, { description = "toggle fullscreen" }),
	awful.key({ env.modkey, "Control" }, "space", awful.client.floating.toggle, { description = "toggle floating" })
)

M.clientbuttons = gears.table.join(
	-- Normal click to focus
	awful.button({}, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
	end),

	-- Mod + Left Click: Move (set_position_floating)
	awful.button({ env.modkey }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		c.floating = true
		awful.mouse.client.move(c)
	end),

	-- Mod + Shift + Left Click: Resize (set_size_floating)
	awful.button({ env.modkey, "Shift" }, 1, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		c.floating = true
		awful.mouse.client.resize(c)
	end),

	-- Mod + Right Click: Resize (keeping this as a backup)
	awful.button({ env.modkey }, 3, function(c)
		c:emit_signal("request::activate", "mouse_click", { raise = true })
		c.floating = true
		awful.mouse.client.resize(c)
	end)
)

M.taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ env.modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle)
)

M.tasklist_buttons = gears.table.join(awful.button({}, 1, function(c)
	if c == client.focus then
		c.minimized = true
	else
		c:emit_signal("request::activate", "tasklist", { raise = true })
	end
end))

for i = 1, 5 do
	M.globalkeys = gears.table.join(
		M.globalkeys,
		awful.key({ env.modkey }, "#" .. i + 9, function()
			local screen = awful.screen.focused()
			local tag = screen.tags[i]
			if tag then
				tag:view_only()
			end
		end, { description = "view tag " .. i }),
		awful.key({ env.modkey, "Shift" }, "#" .. i + 9, function()
			if client.focus then
				local tag = client.focus.screen.tags[i]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end, { description = "move to tag " .. i })
	)
end

return M
