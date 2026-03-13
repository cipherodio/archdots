local gfs = require("gears.filesystem")
local M = {}

-- Palette
M.black = "#282c34"
M.lblack = "#31353f"
M.white = "#abb2bf"
M.blue = "#73b8f1"
M.green = "#98c379"
M.red = "#e06c75"
M.orange = "#d19a66"

-- UI Colors
M.bg_normal = M.black
M.fg_normal = M.white
M.border_normal = M.black
M.border_focus = M.blue

-- Layout icons
local icon_path = gfs.get_themes_dir() .. "default/layouts/"

-- Standard Tiling
M.layout_tile = icon_path .. "tilew.png"
M.layout_tileleft = icon_path .. "tileleftw.png"
M.layout_tilebottom = icon_path .. "tilebottomw.png"
M.layout_tiletop = icon_path .. "tiletopw.png"

-- Fair / Grid
M.layout_fairh = icon_path .. "fairhw.png"
M.layout_fairv = icon_path .. "fairvw.png"

-- Spiral / Dwindle
M.layout_spiral = icon_path .. "spiralw.png"
M.layout_dwindle = icon_path .. "dwindlew.png"

-- Max / Floating / Magnifier
M.layout_max = icon_path .. "maxw.png"
M.layout_fullscreen = icon_path .. "fullscreenw.png"
M.layout_floating = icon_path .. "floatingw.png"
M.layout_magnifier = icon_path .. "magnifierw.png"

-- Corners (for awful.layout.suit.corner.nw/ne/sw/se)
M.layout_cornernw = icon_path .. "cornernww.png"
M.layout_cornerne = icon_path .. "cornernew.png"
M.layout_cornersw = icon_path .. "cornersww.png"
M.layout_cornerse = icon_path .. "cornersew.png"

-- Taglist
M.taglist_fg_focus = M.green
M.taglist_fg_occupied = M.red
M.taglist_empty = M.white
M.taglist_fg_urgent = M.orange

-- Tasklist
M.tasklist_bg_focus = M.lblack
M.tasklist_fg_focus = M.white

return M
