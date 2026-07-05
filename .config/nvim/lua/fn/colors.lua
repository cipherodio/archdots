local M = {}

-- Gruvbox dark
M.gruvbox = {
    c00 = "#1d2021",
    c01 = "#fb4934",
    c02 = "#b8bb26",
    c03 = "#fabd2f",
    c04 = "#458588",
    c05 = "#b16286",
    c06 = "#689d7a",
    c07 = "#ebdbb2",
}

-- Vague
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

-- Nord
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

-- Active colorscheme
local ACTIVE = "gruvbox"

-- Export active palette as flat table
return M[ACTIVE]
