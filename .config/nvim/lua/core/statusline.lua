local ui = require("utils.colors")

local function _Spacer(n)
    local spaces = string.rep(" ", n)
    return "%#StatuslineTextMain#" .. spaces
end

local function _Align()
    return "%="
end

local function _Truncate()
    return "%<"
end

-- local separators = {
--     arrow = { "", "" },
--     rounded = { "", "" },
--     blank = { "", "" },
-- }

local set_hl = function(group, options)
    local bg = options.bg == nil and "" or "guibg=" .. options.bg
    local fg = options.fg == nil and "" or "guifg=" .. options.fg
    local gui = options.gui == nil and "" or "gui=" .. options.gui

    vim.cmd(string.format("hi %s %s %s %s", group, bg, fg, gui))
end

local highlights = {
    { "StatuslineModeCommand", { fg = ui.gd.c01, bg = ui.gd.c05 } },
    { "StatuslineModeNormal", { fg = ui.gd.c01, bg = ui.gd.c08 } },
    { "StatuslineModeInsert", { fg = ui.gd.c01, bg = ui.gd.c03 } },
    { "StatuslineModeVisual", { fg = ui.gd.c01, bg = ui.gd.c04 } },
    { "StatuslineModeReplace", { fg = ui.gd.c01, bg = ui.gd.c06 } },
    { "StatuslineModeSelect", { fg = ui.gd.c01, bg = ui.gd.c09 } },
    { "StatuslineTextMain", { fg = ui.gd.c10, gui = "bold" } },
    { "StatuslineFilename", { fg = ui.gd.c10, gui = "bold" } },
    { "StatuslineSaved", { fg = ui.gd.c03, gui = "bold" } },
    { "StatuslineNotSaved", { fg = ui.gd.c02, gui = "bold" } },
    { "StatuslineReadOnly", { fg = ui.gd.c09, gui = "bold" } },
    { "GsHeadSign", { fg = ui.gd.c08, gui = "bold" } },
    { "GsAddSign", { fg = ui.gd.c03, gui = "bold" } },
    { "GsChangeSign", { fg = ui.gd.c04, gui = "bold" } },
    { "GsDeleteSign", { fg = ui.gd.c02, gui = "bold" } },
    { "StatuslineLspOn", { fg = ui.gd.c11, gui = "bold" } },
    { "StatuslineLspError", { fg = ui.gd.c02, gui = "bold" } },
    { "StatuslineLspWarning", { fg = ui.gd.c04, gui = "bold" } },
    { "StatuslineLspInfo", { fg = ui.gd.c05, gui = "bold" } },
    { "StatuslineLspHint", { fg = ui.gd.c07, gui = "bold" } },
    { "StatuslineCursorBegin", { fg = ui.gd.c03, gui = "bold" } },
    { "StatuslineCursorEnd", { fg = ui.gd.c02, gui = "bold" } },
    { "StatuslineFiletype", { fg = ui.gd.c12, gui = "bold" } },
    { "StatuslineSepRight", { fg = ui.gd.c03, gui = "bold" } },
}

for _, highlight in ipairs(highlights) do
    set_hl(highlight[1], highlight[2])
end

local function ModeColor()
    local current_mode = vim.api.nvim_get_mode().mode
    local higroup = "%#StatuslineModeCommand#"
    if current_mode == "n" then
        return "%#StatuslineModeNormal#"
        -- higroup = "%#StatuslineModeNormal#"
    elseif current_mode == "i" or current_mode == "ic" then
        return "%#StatuslineModeInsert#"
        -- higroup = "%#StatuslineModeInsert#"
    elseif current_mode == "v" or current_mode == "V" or current_mode == "" then
        return "%#StatuslineModeVisual#"
        -- higroup = "%#StatuslineModeVisual#"
    elseif current_mode == "R" or current_mode == "Rv" then
        return "%#StatuslineModeReplace#"
        -- higroup = "%#StatuslineModeReplace#"
    elseif current_mode == "s" or current_mode == "S" or current_mode == "" then
        return "%#StatuslineModeSelect#"
        -- higroup = "%#StatuslineModeSelect#"
    elseif current_mode == "c" then
        return "%#StatuslineModeCommand#"
        -- higroup = "%#StatuslineModeCommand#"
    end
    return higroup
end

local function Mode()
    local modes = {
        ["n"] = "NORMAL",
        ["no"] = "NORMAL",
        ["i"] = "INSERT",
        ["ic"] = "INSERT",
        ["v"] = "VISUAL",
        ["V"] = "V-LINE",
        [""] = "V-BLOCK",
        ["s"] = "SELECT",
        ["S"] = "S-LINE",
        [""] = "S-BLOCK",
        ["R"] = "REPLACE",
        ["Rv"] = "V-REPLACE",
        ["c"] = "COMMAND",
        ["cv"] = "VIM EX",
        ["ce"] = "EX",
        ["r"] = "PROMPT",
        ["rm"] = "MOAR",
        ["r?"] = "CONFIRM",
        ["!"] = "SHELL",
        ["t"] = "TERMINAL",
        ["niI"] = "INS-NOR",
    }
    local current_mode = vim.api.nvim_get_mode().mode
    local value = ""
    if modes[current_mode] == nil then
        value = "UNKNOWN"
    else
        value = modes[current_mode]
    end
    return ModeColor() .. "  " .. value .. " " .. _Spacer(0)
end

local function Filename()
    local filename = vim.fn.expand("%:~:t")
    local path = vim.fn.expand("%:~:.:h")
    local higroup = "%#StatuslineFilename#"
    if filename == "" then
        return _Spacer(1) .. higroup .. "[No Name]"
    end
    if path == "." then
        return _Spacer(1) .. higroup .. filename
    end
    return higroup .. filename
end

local function Modified()
    local buf_modified = vim.bo.modified
    local buf_modifiable = vim.bo.modifiable
    local buf_readonly = vim.bo.readonly
    local hi_saved = "%#StatuslineSaved#"
    local hi_notsaved = "%#StatuslineNotSaved#"
    local hi_readonly = "%#StatuslineReadOnly#"
    if buf_modified then
        return _Spacer(1) .. hi_notsaved .. " " .. _Spacer(0)
    elseif buf_modifiable == false or buf_readonly == true then
        return _Spacer(1) .. hi_readonly .. " • " .. _Spacer(0)
    else
        return _Spacer(1) .. hi_saved .. " " .. _Spacer(0)
    end
end

local function GitSigns()
    if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
        return ""
    end

    local git_status = vim.b.gitsigns_status_dict
    local git_head = vim.b.gitsigns_head
    local branch_name = "%#GsHeadSign#" .. "  " .. git_head .. ""
    local added = (git_status.added and git_status.added ~= 0)
            and ("%#GsAddSign#" .. "  " .. git_status.added)
        or ""
    local changed = (git_status.changed and git_status.changed ~= 0)
            and ("%#GsChangeSign#" .. "  " .. git_status.changed)
        or ""
    local removed = (git_status.removed and git_status.removed ~= 0)
            and ("%#GsDeleteSign#" .. "  " .. git_status.removed)
        or ""

    return table.concat({ branch_name, added, changed, removed })
    -- return branch_name .. added .. changed .. removed
end

local function LspStatus()
    local clients = vim.lsp.get_clients()
    local higroup = "%#StatuslineLspOn#"
    if #clients > 0 then
        return higroup .. "LSP" .. _Spacer(2)
    else
        return ""
    end
end

local function Diagnostics()
    local count_error =
        #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    local count_warning =
        #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    local count_info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    local count_hint = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
    local diag_count = 0
    local icon_error = " "
    local icon_warning = " "
    local icon_info = " "
    local icon_hint = " "
    local higroup_error = "%#StatuslineLspError#"
    local higroup_warning = "%#StatuslineLspWarning#"
    local higroup_info = "%#StatuslineLspInfo#"
    local higroup_hint = "%#StatuslineLspHint#"
    local error, warning, info, hint = "", "", "", ""
    if count_error == 0 then
        error = ""
    else
        error = higroup_error .. icon_error .. count_error .. _Spacer(1)
    end
    if count_warning == 0 then
        warning = ""
    else
        warning = higroup_warning .. icon_warning .. count_warning .. _Spacer(1)
    end
    if count_info == 0 then
        info = ""
    else
        info = higroup_info .. icon_info .. count_info .. _Spacer(1)
    end
    if count_hint == 0 then
        hint = ""
    else
        hint = higroup_hint .. icon_hint .. count_hint .. _Spacer(1)
    end
    if count_error + count_warning + count_info + count_hint == 0 then
        diag_count = 0
    else
        diag_count = 1
    end
    return error .. warning .. info .. hint .. _Spacer(diag_count)
end

local function Percentage()
    local current_line = vim.fn.line(".")
    local total_lines = vim.fn.line("$")
    local percentage = vim.fn.floor(current_line / total_lines * 100)
    local content = ""
    local higroupmain = "%#StatuslineTextMain#"
    local higroupaccent = "%#StatuslineTextMain#"
    if current_line == 1 then
        content = "Top"
    elseif current_line == total_lines then
        content = "End"
    elseif percentage < 10 then
        content = higroupaccent .. "·" .. higroupmain .. percentage .. "%%"
    else
        content = percentage .. "%%"
    end
    return higroupaccent .. "󰉸 " .. higroupmain .. content .. _Spacer(2)
end

local function CursorPosition()
    local current_line = vim.fn.line(".")
    local total_lines = vim.fn.line("$")
    local current_col = vim.fn.virtcol(".")
    local total_col = vim.fn.virtcol("$")
    local higroupmain = "%#StatuslineTextMain#"
    local startlinecolor = "%#StatuslineCursorBegin#"
    local endlinecolor = "%#StatuslineCursorEnd#"
    return startlinecolor
        .. current_line
        .. higroupmain
        .. ":"
        .. endlinecolor
        .. total_lines
        .. higroupmain
        .. " "
        .. ""
        .. " "
        .. startlinecolor
        .. current_col
        .. ":"
        .. endlinecolor
        .. total_col
        .. _Spacer(2)
end

---@diagnostic disable-next-line: unused-function, unused-local
local function Filetype()
    local higroup = "%#StatuslineFiletype#"
    local filetype = vim.bo.filetype:upper()
    if filetype == "" then
        return higroup .. "-" .. _Spacer(2)
    else
        return higroup .. filetype .. _Spacer(2)
    end
end

local function Path()
    local path = vim.fn.expand("%:~:.:h")
    local higroup = "%#StatuslineTextMain#"
    local max_width = 30
    if path == "." or path == "" then
        return ""
    elseif #path > max_width then
        path = "…" .. string.sub(path, -max_width + 2)
    end
    return _Spacer(1) .. higroup .. path .. "/"
end

Statusline = function()
    return table.concat({
        Mode(),
        Path(),
        Filename(),
        Modified(),
        GitSigns(),
        _Spacer(2),
        _Align(),
        Diagnostics(),
        LspStatus(),
        Percentage(),
        CursorPosition(),
        _Truncate(),
    })
end

vim.api.nvim_create_augroup("Statusline", { clear = true })
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    group = "Statusline",
    pattern = "*",
    callback = function()
        vim.o.statusline = "%!v:lua.Statusline()"
    end,
})

-- Last Modified: Mon, 08 Dec 2025 07:07:18 PM
