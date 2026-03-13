pcall(require, "luarocks.loader")
require("modules.errorhandler")

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")

-- Global
beautiful.init(gears.filesystem.get_configuration_dir() .. "themes/onedark.lua")
beautiful.font = "monospace 14"
beautiful.useless_gap = 2
beautiful.border_width = 1

-- Modules
local bindings = require("modules.bindings")
local rules = require("modules.rules")
awful.rules.rules = rules
local wibar = require("modules.wibar")

-- Keys
root.keys(bindings.globalkeys)

-- Layouts
awful.layout.layouts = require("modules.layouts")
awful.screen.connect_for_each_screen(function(s)
	awful.tag({ "1", "2", "3", "4", "5" }, s, awful.layout.layouts[1])
	wibar.setup(s)
end)

-- Signals
require("modules.signals")
