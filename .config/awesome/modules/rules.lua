local bindings = require("modules.bindings")
local awful = require("awful")
local beautiful = require("beautiful")

local M = {}

M.rules = {
	-- Global rules
	{
		rule = {},
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = bindings.clientkeys,
			buttons = bindings.clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
		},
	},
	-- Floating rules | Force float in center
	{
		rule_any = {
			instance = {
				"DTA",
				"copyq",
				"pinentry",
			},
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin",
				"Sxiv",
				"Tor Browser",
				"Wpa_gui",
				"veromix",
				"xtightvncviewer",
				"ssh-askpass",
				"Pinentry-gtk",
				"confirmreset",
				"makebranch",
				"maketag",
				"zenity",
				"Steam setup",
				"mpv",
			},
			name = {
				"Event Tester",
				"pinentry",
				"branchdialog",
				"Steam Settings",
				"Downloading spotify",
				"Blender Render",
			},
			role = {
				"AlarmWindow",
				"ConfigManager",
				"pop-up",
				"GtkFileChooserDialog",
				-- "dialog",
			},
		},
		properties = {
			floating = true,
			placement = awful.placement.centered,
		},
	},
	-- Titlebar rule
	{
		rule_any = { type = { "dialog", "normal" } },
		properties = { titlebars_enabled = false },
	},
	-- Tag assignments
	{
		rule_any = { class = { "firefox", "Firefox" } },
		properties = { screen = 1, tag = "1" },
	},
	{
		rule_any = {
			class = { "Steam", "steam" },
			name = { "Steam setup", "Steam", "steam" },
		},
		properties = { screen = 1, tag = "4" },
	},
	{
		rule = { class = "Audacity" },
		callback = function(c)
			if c.type == "dialog" or c.name:match("Preferences") then
				c.floating = true
				awful.placement.centered(c)
			elseif c.type == "normal" then
				c.floating = false
				c.maximized = false
				c.size_hints_honor = false
			else
				c.floating = true
			end
		end,
	},
	{
		rule = { class = "Audacity", type = "splash" },
		properties = { floating = true, focus = false, placement = awful.placement.centered },
	},
}

return M.rules
