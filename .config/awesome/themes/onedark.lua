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
local icon_path = "/usr/share/awesome/themes/default/layouts/"
M.layout_tile = icon_path .. "tilew.png"
M.layout_tileleft = icon_path .. "tileleftw.png"
M.layout_floating = icon_path .. "floatingw.png"
M.layout_max = icon_path .. "maxw.png"
M.layout_fullscreen = icon_path .. "fullscreenw.png"

-- Taglist
M.taglist_fg_focus = M.green
M.taglist_fg_occupied = M.red
M.taglist_empty = M.white
M.taglist_fg_urgent = M.orange

-- Tasklist
M.tasklist_bg_focus = M.lblack
M.tasklist_fg_focus = M.white

return M
