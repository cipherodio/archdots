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
    c08 = "#ebdbb2",
    c09 = "#fe8019",
    c10 = "#83a598",
    c11 = "#32302f",
}

M.onedark = {
    c00 = "#282c34",
    c01 = "#3e4452",
    c02 = "#e06c75",
    c03 = "#98c379",
    c04 = "#e5c07b",
    c05 = "#61afef",
    c06 = "#c678dd",
    c07 = "#56b6c2",
    c08 = "#abb2bf",
    c09 = "#d19a66",
    c10 = "#73b8f1",
    c11 = "#31353f",
}

-- Active colorscheme
local ACTIVE = "onedark"

-- Export active palette as flat table
return M[ACTIVE]
