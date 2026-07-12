local theme = require("fn.theme")

local M = {}

M.gruvbox = {
    dark = {
        c00 = "#1d2021",
        c01 = "#fb4934",
        c02 = "#b8bb26",
        c03 = "#fabd2f",
        c04 = "#458588",
        c05 = "#b16286",
        c06 = "#689d7a",
        c07 = "#ebdbb2",
    },
    light = {
        c00 = "#fbf1c7",
        c01 = "#cc241d",
        c02 = "#98971a",
        c03 = "#d79921",
        c04 = "#458588",
        c05 = "#b16286",
        c06 = "#689d6a",
        c07 = "#3c3836",
    },
}

M.vague = {
    c00 = "#252530",
    c01 = "#d8647e",
    c02 = "#7fa563",
    c03 = "#f3be7c",
    c04 = "#6e94b2",
    c05 = "#bb9dbd",
    c06 = "#aeaed1",
    c07 = "#cdcdcd",
}

M.nord = {
    c00 = "#2e3440",
    c01 = "#bf616a",
    c02 = "#a3be8c",
    c03 = "#ebcb8b",
    c04 = "#81a1c1",
    c05 = "#b48ead",
    c06 = "#88c0d0",
    c07 = "#d8dee9",
}

local active = "gruvbox"

function M.current()
    local palette = M[active]

    if palette.dark and palette.light then
        return palette[theme.mode()]
    end

    return palette
end

return M
