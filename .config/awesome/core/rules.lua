local awful = require("awful")
local beautiful = require("beautiful")

-- NOTE: relies on `clientkeys` and `clientbuttons` globals, which must be
-- loaded (bindings/clientkeys.lua, bindings/clientbuttons.lua) before this file.
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            size_hints_honor = false,
        },
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                "DTA", -- Firefox addon DownThemAll.
                "copyq",
                "pinentry",
            },
            class = {
                "Blueman-manager",
                "Gpick",
                "Kruler",
                "MessageWin",
                "Nsxiv",
                "Wpa_gui",
            },
            name = {
                "Event Tester",
            },
            role = {
                "AlarmWindow",
                "ConfigManager",
                "pop-up",
            },
        },
        properties = { floating = true },
    },
    {
        rule = { class = "firefox" },
        properties = { tag = "1" },
    },
    {
        rule_any = { class = { "Stardew Valley", "StardewModdingAPI" } },
        properties = { floating = false },
    },
}
