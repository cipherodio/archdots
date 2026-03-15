local awful = require("awful")

local M = {}

function M.toggle(cmd, instance_name)
    local target = nil
    for _, c in ipairs(client.get()) do
        if c.instance == instance_name then
            target = c
            break
        end
    end

    if not target then
        -- This spawns the terminal and assigns it the instance name for the rule to catch
        awful.spawn(string.format("alacritty --class %s -e %s", instance_name, cmd))
    else
        if target.minimized then
            target.minimized = false
            target:raise()
            client.focus = target
        else
            target.minimized = true
        end
    end
end

return M
