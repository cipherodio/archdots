local M = {}

-- Gruvbox dark contrast
M.gruvbox = {
    c00 = "#1d2021",
    c01 = "#282828",
    c02 = "#cc241d",
    c03 = "#98971a",
    c04 = "#d79921",
    c05 = "#458588",
    c06 = "#b16286",
    c07 = "#689d7a",
    c08 = "#a89984",
    c09 = "#928374",
    c10 = "#fb4934",
    c11 = "#b8bb26",
    c12 = "#fabd2f",
    c13 = "#83a598",
    c14 = "#d3869b",
    c15 = "#8ec07c",
    c16 = "#ebdbb2",
}

-- Onedark warmer
M.onedark = {
    c00 = "#232326",
    c01 = "#2c2d31",
    c02 = "#de5d68",
    c03 = "#8fb573",
    c04 = "#dbb671",
    c05 = "#57a5e5",
    c06 = "#bb70d2",
    c07 = "#51a8b3",
    c08 = "#a7aab0",
    c09 = "#5a5b5e",
    c10 = "#833b3b",
    c11 = "#7c5c20",
    c12 = "#e2c792",
    c13 = "#68aee8",
    c14 = "#79428a",
    c15 = "#2b5d63",
    c16 = "#818387",
}

-- Active colorscheme
local ACTIVE = "onedark"

-- Export active palette as flat table
return M[ACTIVE]

-- Last Modified: Thu, 08 Jan 2026 06:32:25 PM
