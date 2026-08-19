-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome libraries
local gears = require("gears")
require("awful")
require("awful.autofocus")
require("wibox")
local beautiful = require("beautiful")

-- Themes define colours, icons, font. (No naughty — see core/error-handling.lua)
beautiful.init(gears.filesystem.get_configuration_dir() .. "ui/theme.lua")
require("ui.options")

-- Load order matters:
--   1. core.vars     -- terminal/editor/modkey/layouts, needed by everything below
--   2. ui.bar         -- statusbar + mypromptbox, needed by bindings/globalkeys
--   3. bindings.*     -- clientkeys/clientbuttons/globalkeys, needed by core.rules
--   4. core.rules     -- references clientkeys/clientbuttons globals
--   5. core.signals   -- client signal handling
--   6. core.error-handling -- last, so it can catch errors from anything above

require("core.vars")
require("ui.bar")

require("bindings.clientkeys")
require("bindings.clientbuttons")
require("bindings.globalkeys")
require("bindings.userkeys")
require("bindings.mouse")
root.keys(globalkeys)

require("core.rules")
require("core.signals")
require("core.error-handling")
