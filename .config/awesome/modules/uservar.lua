local M = {}

M.modkey = "Mod4"
M.altkey = "Mod1"
M.terminal = "alacritty"
M.editor = "nvim"
M.editor_cmd = M.terminal .. " -e " .. M.editor
M.rofi_cmd = "rofi -show drun"
M.browser = "firefox"

return M
