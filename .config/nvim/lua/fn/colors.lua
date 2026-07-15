local theme = require("fn.theme")

local M = {}

M.gruvbox = {
    dark = {
        bg = "#1d2021",
        c00 = "#282828",
        c01 = "#cc241d",
        c02 = "#98971a",
        c03 = "#d79921",
        c04 = "#458588",
        c05 = "#b16286",
        c06 = "#689d6a",
        c07 = "#a89984",
        c08 = "#928374",
        c09 = "#fb4934",
        c10 = "#b8bb26",
        c11 = "#fabd2f",
        c12 = "#83a598",
        c13 = "#d3869b",
        c14 = "#8ec07c",
        c15 = "#ebdbb2",
        c16 = "#3c3836",
        c17 = "#504945",
        c18 = "#fe8019",
    },
    light = {
        bg = "#fbf1c7",
        c00 = "#fdf4c1",
        c01 = "#cc241d",
        c02 = "#98971a",
        c03 = "#d79921",
        c04 = "#458588",
        c05 = "#b16286",
        c06 = "#689d6a",
        c07 = "#7c6f64",
        c08 = "#928374",
        c09 = "#9d0006",
        c10 = "#79740e",
        c11 = "#b57614",
        c12 = "#076678",
        c13 = "#8f3f71",
        c14 = "#427b58",
        c15 = "#3c3836",
        c16 = "#ebdbb2",
        c17 = "#d5c4a1",
        c18 = "#af3a03",
    },
}

M.nightfox = {
    dark = {
        bg = "#192330",
        c00 = "#131a24",
        c01 = "#c94f6d",
        c02 = "#81b29a",
        c03 = "#dbc074",
        c04 = "#719cd6",
        c05 = "#9d79d6",
        c06 = "#63cdcf",
        c07 = "#dfdfe0",
        c08 = "#738091",
        c09 = "#c94f6d",
        c10 = "#81b29a",
        c11 = "#dbc074",
        c12 = "#719cd6",
        c13 = "#9d79d6",
        c14 = "#63cdcf",
        c15 = "#cdcecf",
        c16 = "#212e3f",
        c17 = "#29394f",
        c18 = "#f4a261",
    },
    light = {
        bg = "#faf4ed",
        c00 = "#fffaf3",
        c01 = "#b4637a",
        c02 = "#618774",
        c03 = "#ea9d34",
        c04 = "#286983",
        c05 = "#907aa9",
        c06 = "#56949f",
        c07 = "#575279",
        c08 = "#9893a5",
        c09 = "#b4637a",
        c10 = "#618774",
        c11 = "#ea9d34",
        c12 = "#286983",
        c13 = "#907aa9",
        c14 = "#56949f",
        c15 = "#575279",
        c16 = "#fffaf3",
        c17 = "#f2e9e1",
        c18 = "#d7827e",
    },
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
