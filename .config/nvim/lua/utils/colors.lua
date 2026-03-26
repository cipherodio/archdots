local M = {}

-- Gruvbox dark contrast
M.gruvbox = {
    c00 = "#1d2021",
    c01 = "#cc241d",
    c02 = "#98971a",
    c03 = "#d79921",
    c04 = "#458588",
    c05 = "#b16286",
    c06 = "#689d7a",
    c07 = "#ebdbb2",
    c08 = "#928374",
}

-- Onedark
M.onedark = {
    c00 = "#282c34",
    c01 = "#e06c75",
    c02 = "#98c379",
    c03 = "#e5c07b",
    c04 = "#61afef",
    c05 = "#c678dd",
    c06 = "#56b6c2",
    c07 = "#abb2bf",
    c08 = "#5c6370",
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
    c08 = "#616e88",
}

-- Active colorscheme
local ACTIVE = "nord"

-- Export active palette as flat table
return M[ACTIVE]
