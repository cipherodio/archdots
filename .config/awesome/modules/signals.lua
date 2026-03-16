local awful = require("awful")
local beautiful = require("beautiful")
local bindings = require("modules.bindings")

-- New client behavior
client.connect_signal("manage", function(c)
    c:buttons(bindings.clientbuttons)
    if not awesome.startup then
        awful.client.setslave(c)
    end
    if
        awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position
    then
        awful.placement.no_offscreen(c)
    end
end)

-- Border colors
client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus or "#73b8f1"
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal or "#282c34"
end)

-- Tags urgency color
client.connect_signal("request::activate", function(c, _, _)
    if not awesome.startup then
        if c.first_tag and not c.first_tag.selected then
            c.urgent = true
        end
    end
end)
client.connect_signal("focus", function(c)
    if c.urgent then
        c.urgent = false
    end
end)
