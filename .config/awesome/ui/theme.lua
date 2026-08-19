local colors = require("fn.colors")
local gears = require("gears")
local theme = {}

-- Core colors, all pulled from your gruvbox palette
theme.bg_normal = colors.gruvbox.bg
theme.bg_focus = colors.gruvbox.c17
theme.bg_urgent = colors.gruvbox.c01
theme.bg_minimize = colors.gruvbox.c00
theme.bg_systray = theme.bg_normal
theme.fg_normal = colors.gruvbox.c15
theme.fg_focus = colors.gruvbox.c15
theme.fg_urgent = colors.gruvbox.c15
theme.fg_minimize = colors.gruvbox.c08

-- Disable loading circle cursor
theme.enable_spawn_cursor = false

-- Borders — the values your signals.lua / rules.lua already read
theme.useless_gap = 1
theme.border_width = 2
theme.border_normal = colors.gruvbox.c17
theme.border_focus = colors.gruvbox.c09
theme.border_marked = colors.gruvbox.c03

-- Taglist colors (the tag numbers in your wibar)
theme.taglist_bg_focus = colors.gruvbox.c04
theme.taglist_fg_focus = colors.gruvbox.c00
theme.taglist_bg_occupied = colors.gruvbox.bg
theme.taglist_fg_occupied = colors.gruvbox.c10
theme.taglist_bg_empty = colors.gruvbox.bg
theme.taglist_fg_empty = colors.gruvbox.c08

-- Tasklist
-- theme.tasklist_bg_normal = colors.gruvbox.bg
-- theme.tasklist_fg_normal = colors.gruvbox.c15
theme.tasklist_bg_focus = colors.gruvbox.c04
theme.tasklist_fg_focus = colors.gruvbox.c00

-- Hotkeys help
theme.hotkeys_fg = colors.gruvbox.c15
theme.hotkeys_bg = colors.gruvbox.bg
theme.hotkeys_modifiers_fg = colors.gruvbox.c08

-- Layout icons (tile/floating/max/etc. shown in s.mylayoutbox) —
-- reusing the stock icon graphics here, not stock colors/fonts.
local icon_path = gears.filesystem.get_themes_dir() .. "default/"
theme.layout_fairh = icon_path .. "layouts/fairhw.png"
theme.layout_fairv = icon_path .. "layouts/fairvw.png"
theme.layout_floating = icon_path .. "layouts/floatingw.png"
theme.layout_magnifier = icon_path .. "layouts/magnifierw.png"
theme.layout_max = icon_path .. "layouts/maxw.png"
theme.layout_fullscreen = icon_path .. "layouts/fullscreenw.png"
theme.layout_tilebottom = icon_path .. "layouts/tilebottomw.png"
theme.layout_tileleft = icon_path .. "layouts/tileleftw.png"
theme.layout_tile = icon_path .. "layouts/tilew.png"
theme.layout_tiletop = icon_path .. "layouts/tiletopw.png"
theme.layout_spiral = icon_path .. "layouts/spiralw.png"
theme.layout_dwindle = icon_path .. "layouts/dwindlew.png"
theme.layout_cornernw = icon_path .. "layouts/cornernww.png"

return theme
