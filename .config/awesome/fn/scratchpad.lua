local awful = require("awful")

local M = {}

-- Registry of scratchpads. `match` picks which client property to check:
--   "instance" — for terminal-spawned pads, matched via st's -n flag
--   "class"    — for apps you don't control launch flags for (e.g. Spotify),
--                 matched against their actual WM_CLASS (confirm via xprop)

-- For st terminal
local definitions = {
    spterm = {
        cmd = terminal .. " -n spterm -g 120x35",
        match = "instance",
        value = "spterm",
    },
    sphtop = {
        cmd = terminal .. " -n sphtop -g 120x35 -e htop",
        match = "instance",
        value = "sphtop",
    },
    spbtop = {
        cmd = terminal .. " -n spbtop -g 120x35 -e btop",
        match = "instance",
        value = "spbtop",
    },
    sptask = {
        cmd = terminal .. " -n sptask -g 120x35 -e taskwarrior-tui",
        match = "instance",
        value = "sptask",
    },
    sppulse = {
        cmd = terminal .. " -n sppulse -g 90x25 -e pulsemixer",
        match = "instance",
        value = "sppulse",
    },
    spmusic = {
        cmd = terminal .. " -n spmusic -g 120x35 -e ncmpcpp",
        match = "instance",
        value = "spmusic",
    },
    spnews = {
        cmd = terminal .. " -n spnews -g 120x35 -e newsboat",
        match = "instance",
        value = "spnews",
    },
    spfm = {
        cmd = terminal .. " -n spfm -g 120x35 -e lf",
        match = "instance",
        value = "spfm",
    },
    spnet = {
        cmd = terminal .. " -n spnet -g 90x25 -e nmtui",
        match = "instance",
        value = "spnet",
    },
    spotify = {
        cmd = "spotify",
        match = "class",
        value = "Spotify",
    },
}

local clients = {} -- name -> live client object, once one has been spawned

function M.toggle(name)
    local def = definitions[name]
    if not def then
        return
    end

    local c = clients[name]
    if c and c.valid then
        if c.hidden then
            c.hidden = false
            c:raise()
            client.focus = c
        else
            c.hidden = true
        end
    else
        awful.spawn(def.cmd)
    end
end

client.connect_signal("manage", function(c)
    for name, def in pairs(definitions) do
        local prop = (def.match == "class") and c.class or c.instance
        if prop == def.value then
            clients[name] = c
            c.floating = true
            c.ontop = true
            c.skip_taskbar = true
            awful.placement.centered(c)
            break
        end
    end
end)

return M
