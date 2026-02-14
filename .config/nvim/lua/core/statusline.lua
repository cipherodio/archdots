local ui = require("utils.colors")

-- Helpers
local function Spacer(n)
    return "%#StatuslineTextMain#" .. string.rep(" ", n)
end

local function Align()
    return "%="
end

local function Truncate()
    return "%<"
end

-- Highlight helper (colorscheme-safe)
local function set_hl(group, opts)
    vim.api.nvim_set_hl(0, group, {
        fg = opts.fg,
        bg = opts.bg,
        bold = opts.gui == "bold",
    })
end

-- Highlight definitions / Palette agnostic
local highlights = {
    { "StatuslineModeCommand", { fg = ui.c00, bg = ui.c05 } },
    { "StatuslineModeNormal", { fg = ui.c00, bg = ui.c06, gui = "bold" } },
    { "StatuslineModeInsert", { fg = ui.c00, bg = ui.c03, gui = "bold" } },
    { "StatuslineModeVisual", { fg = ui.c00, bg = ui.c04, gui = "bold" } },
    { "StatuslineModeReplace", { fg = ui.c00, bg = ui.c06, gui = "bold" } },
    { "StatuslineModeSelect", { fg = ui.c00, bg = ui.c09, gui = "bold" } },

    { "StatuslineTextMain", { fg = ui.c10, bg = ui.c11, gui = "bold" } },
    { "StatuslineFilename", { fg = ui.c10, bg = ui.c11, gui = "bold" } },

    { "StatuslineSaved", { fg = ui.c03, bg = ui.c11, gui = "bold" } },
    { "StatuslineNotSaved", { fg = ui.c02, bg = ui.c11, gui = "bold" } },
    { "StatuslineReadOnly", { fg = ui.c09, bg = ui.c11, gui = "bold" } },

    { "GsHeadSign", { fg = ui.c02, bg = ui.c11, gui = "bold" } },
    { "GsAddSign", { fg = ui.c03, bg = ui.c11, gui = "bold" } },
    { "GsChangeSign", { fg = ui.c04, bg = ui.c11, gui = "bold" } },
    { "GsDeleteSign", { fg = ui.c02, bg = ui.c11, gui = "bold" } },

    { "StatuslineLspOn", { fg = ui.c05, bg = ui.c11, gui = "bold" } },
    { "StatuslineLspError", { fg = ui.c02, bg = ui.c11, gui = "bold" } },
    { "StatuslineLspWarning", { fg = ui.c04, bg = ui.c11, gui = "bold" } },
    { "StatuslineLspInfo", { fg = ui.c05, bg = ui.c11, gui = "bold" } },
    { "StatuslineLspHint", { fg = ui.c07, bg = ui.c11, gui = "bold" } },

    { "StatuslineCursorBegin", { fg = ui.c08, bg = ui.c11, gui = "bold" } },
    { "StatuslineCursorEnd", { fg = ui.c08, bg = ui.c11, gui = "bold" } },
    { "StatuslinePercent", { fg = ui.c10, bg = ui.c11, gui = "bold" } },
    { "StatuslineFiletype", { fg = ui.c08, gui = "bold" } },
}

-- Apply highlights (fix for onedark.nvim reset)
local function apply_highlights()
    for _, hl in ipairs(highlights) do
        set_hl(hl[1], hl[2])
    end
end

apply_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = apply_highlights,
})

-- Mode
local mode_names = {
    n = "NORMAL",
    i = "INSERT",
    v = "VISUAL",
    V = "V-LINE",
    [""] = "V-BLOCK",
    R = "REPLACE",
    c = "COMMAND",
    t = "TERMINAL",
}

local function ModeColor()
    local m = vim.api.nvim_get_mode().mode
    if m == "n" then
        return "%#StatuslineModeNormal#"
    elseif m:find("i") then
        return "%#StatuslineModeInsert#"
    elseif m:find("v") or m == "" then
        return "%#StatuslineModeVisual#"
    elseif m:find("R") then
        return "%#StatuslineModeReplace#"
    elseif m:find("s") then
        return "%#StatuslineModeSelect#"
    elseif m == "c" then
        return "%#StatuslineModeCommand#"
    end
    return "%#StatuslineModeCommand#"
end

local function Mode()
    local m = vim.api.nvim_get_mode().mode
    return ModeColor() .. "  " .. (mode_names[m] or "UNKNOWN") .. " "
end

-- Path ORIGINAL
-- local function Path()
--     local path = vim.fn.expand("%:~:.:h")
--     if path == "" or path == "." then
--         return ""
--     end
--     if #path > 30 then
--         path = "…" .. path:sub(-28)
--     end
--     return Spacer(1) .. "%#StatuslineTextMain#" .. path .. "/"
-- end

-- Filename ORIGINAL
-- local function Filename()
--     local name = vim.fn.expand("%:t")
--     if name == "" then
--         return Spacer(1) .. "%#StatuslineFilename#[No Name]"
--     end
--     return Spacer(1) .. "%#StatuslineFilename#" .. name
-- end

--- TEST ---
local function Path()
    local path = vim.fn.expand("%:~:.:h")
    local max_width = 30
    if path == "." or path == "" then
        return ""
    elseif #path > max_width then
        path = "…" .. string.sub(path, -max_width + 2)
    end
    return Spacer(1) .. "%#StatuslineTextMain#" .. path .. "/"
end

local function Filename()
    local filename = vim.fn.expand("%:~:t")
    local path = vim.fn.expand("%:~:.:h")
    if filename == "" then
        return Spacer(1) .. "%#StatuslineFilename#" .. "[No Name]"
    end
    if path == "." then
        return Spacer(1) .. "%#StatuslineFilename#" .. filename
    end
    return "%#StatuslineFilename#" .. filename
end
--- TEST ---

-- Modified / Readonly
local function Modified()
    if vim.bo.modified then
        return Spacer(1) .. "%#StatuslineNotSaved# "
    elseif not vim.bo.modifiable or vim.bo.readonly then
        return Spacer(1) .. "%#StatuslineReadOnly#• "
    end
    return Spacer(1) .. "%#StatuslineSaved# "
end

-- GitSigns
local function GitSigns()
    if not vim.b.gitsigns_head or not vim.b.gitsigns_status_dict then
        return ""
    end

    local g = vim.b.gitsigns_status_dict
    local out = { "%#GsHeadSign#  " .. vim.b.gitsigns_head }

    if g.added and g.added > 0 then
        table.insert(out, "%#GsAddSign#  " .. g.added)
    end
    if g.changed and g.changed > 0 then
        table.insert(out, "%#GsChangeSign#  " .. g.changed)
    end
    if g.removed and g.removed > 0 then
        table.insert(out, "%#GsDeleteSign#  " .. g.removed)
    end

    return table.concat(out)
end

-- LSP / Diagnostics
local function LspStatus()
    if vim.bo.filetype == "lazy" or vim.bo.buftype == "nofile" then
        return ""
    end
    if #vim.lsp.get_clients({ bufnr = 0 }) > 0 then
        return "%#StatuslineLspOn#LSP" .. Spacer(2)
    end
    return ""
end

local function Diagnostics()
    if vim.bo.filetype == "lazy" or vim.bo.buftype == "nofile" then
        return ""
    end

    local counts = vim.diagnostic.count(0)
    if not counts then
        return ""
    end

    local out = {}
    local sev = vim.diagnostic.severity

    if counts[sev.ERROR] then
        table.insert(out, "%#StatuslineLspError# " .. counts[sev.ERROR] .. Spacer(1))
    end
    if counts[sev.WARN] then
        table.insert(out, "%#StatuslineLspWarning# " .. counts[sev.WARN] .. Spacer(1))
    end
    if counts[sev.INFO] then
        table.insert(out, "%#StatuslineLspInfo# " .. counts[sev.INFO] .. Spacer(1))
    end
    if counts[sev.HINT] then
        table.insert(out, "%#StatuslineLspHint# " .. counts[sev.HINT] .. Spacer(1))
    end

    return table.concat(out)
end

-- Cursor position / Percentage
local function Percentage()
    local l = vim.fn.line(".")
    local t = vim.fn.line("$")

    local label
    if l == 1 then
        label = "Top"
    elseif l == t then
        label = "End"
    else
        label = math.floor((l / t) * 100) .. "%%"
    end

    return "%#StatuslinePercent#󰉸 " .. label .. Spacer(2)
end

local function CursorPosition()
    return "%#StatuslineCursorBegin#"
        .. vim.fn.line(".")
        .. "%#StatuslineTextMain#:"
        .. "%#StatuslineCursorEnd#"
        .. vim.fn.line("$")
        .. "%#StatuslineTextMain#  "
        .. "%#StatuslineCursorBegin#"
        .. vim.fn.virtcol(".")
        .. "%#StatuslineTextMain#:"
        .. "%#StatuslineCursorEnd#"
        .. vim.fn.virtcol("$")
        .. Spacer(2)
end

-- Statusline
function _G.Statusline()
    return table.concat({
        Mode(),
        Path(),
        Filename(),
        Modified(),
        GitSigns(),
        Spacer(2),
        Align(),
        Diagnostics(),
        LspStatus(),
        Percentage(),
        CursorPosition(),
        Truncate(),
    })
end

vim.o.statusline = "%!v:lua.Statusline()"
