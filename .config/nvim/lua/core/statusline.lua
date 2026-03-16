local ui = require("utils.colors")

local function Spacer(n)
    return "%#SpacerHL#" .. string.rep(" ", n or 1)
end
local function Align()
    return "%="
end
local function Truncate()
    return "%<"
end

local function set_hl(group, opts)
    vim.api.nvim_set_hl(0, group, {
        fg = opts.fg,
        bg = opts.bg,
        bold = opts.gui == "bold",
    })
end

local highlights = {
    { "ModeCmd", { fg = ui.c00, bg = ui.c05 } },
    { "ModeNormal", { fg = ui.c00, bg = ui.c03 } },
    { "ModeInsert", { fg = ui.c00, bg = ui.c04 } },
    { "ModeVisual", { fg = ui.c00, bg = ui.c06 } },
    { "ModeReplace", { fg = ui.c00, bg = ui.c06 } },
    { "GitDots", { fg = ui.c05, bg = ui.c11 } },
    { "GitProj", { fg = ui.c04, bg = ui.c11 } },
    { "GitLoose", { fg = ui.c02, bg = ui.c11 } },
    { "LSPSingleBracket", { fg = ui.c02, bg = ui.c11 } },
    { "LSPProjBracket", { fg = ui.c03, bg = ui.c11 } },
    { "SpacerHL", { fg = ui.c10, bg = ui.c11 } },
    { "GitHeadSign", { fg = ui.c02, bg = ui.c11 } },
    { "GitAddSign", { fg = ui.c03, bg = ui.c11 } },
    { "GitChangeSign", { fg = ui.c04, bg = ui.c11 } },
    { "GitDeleteSign", { fg = ui.c02, bg = ui.c11 } },
    { "LSPStat", { fg = ui.c07, bg = ui.c11 } },
    { "LSPError", { fg = ui.c02, bg = ui.c11 } },
    { "LSPWarn", { fg = ui.c04, bg = ui.c11 } },
    { "LSPInfo", { fg = ui.c05, bg = ui.c11 } },
    { "LSPHint", { fg = ui.c07, bg = ui.c11 } },
    { "CursorPos", { fg = ui.c08, bg = ui.c11 } },
}

local function apply_highlights()
    for _, hl in ipairs(highlights) do
        set_hl(hl[1], hl[2])
    end
end

apply_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_highlights })

local Status = {}

local mode_map = {
    n = "n",
    i = "i",
    v = "v",
    V = "v",
    ["\22"] = "v",
    c = "c",
    R = "r",
    t = "t",
}

function Status.Mode()
    local m = vim.api.nvim_get_mode().mode
    local hl = "%#ModeCmd#"

    if m == "n" then
        hl = "%#ModeNormal#"
    elseif m:find("i") then
        hl = "%#ModeInsert#"
    elseif m:find("v") or m == "\22" then
        hl = "%#ModeVisual#"
    elseif m:find("R") then
        hl = "%#ModeReplace#"
    end
    return hl .. " " .. (mode_map[m] or m:sub(1, 1)) .. " "
end

function Status.GitLspContext()
    local g = vim.b.gitsigns_status_dict
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    local is_lsp_project = false
    for _, client in ipairs(clients) do
        if client.root_dir then
            is_lsp_project = true
            break
        end
    end
    local bracket_hl = is_lsp_project and "%#LSPProjBracket#" or "%#LSPSingleBracket#"
    local letter, letter_hl = "L", "%#GitLoose#" --   
    if g and g.gitdir then
        if g.gitdir:find(".dots") then
            letter, letter_hl = "D", "%#GitDots#" -- 
        else
            letter, letter_hl = "P", "%#GitProj#" --   
        end
    end
    return Spacer(1) .. bracket_hl .. "[" .. letter_hl .. letter .. bracket_hl .. "]"
end

function Status.GitSigns()
    local g = vim.b.gitsigns_status_dict

    if not g or not g.head then
        return ""
    end
    local out = { "%#GitHeadSign# " .. g.head } -- 
    if (g.added or 0) > 0 then
        table.insert(out, "%#GitAddSign# +" .. g.added) -- 
    end
    if (g.changed or 0) > 0 then
        table.insert(out, "%#GitChangeSign# ~" .. g.changed) -- 
    end
    if (g.removed or 0) > 0 then
        table.insert(out, "%#GitDeleteSign# -" .. g.removed) -- 
    end
    return table.concat(out)
end

function Status.LspStatus()
    local clients = vim.lsp.get_clients({ bufnr = 0 })

    if #clients == 0 then
        return ""
    end
    local names = {}
    for _, client in ipairs(clients) do
        table.insert(names, client.name)
    end
    return Spacer(1) .. "%#LSPStat#[" .. table.concat(names, ",") .. "]"
end

function Status.Diagnostics()
    if vim.bo.filetype == "lazy" or vim.bo.buftype == "nofile" then
        return ""
    end
    local counts = vim.diagnostic.count(0)
    local out, sev = {}, vim.diagnostic.severity
    if counts[sev.ERROR] then
        table.insert(out, "%#LSPError# " .. counts[sev.ERROR] .. Spacer(1))
    end
    if counts[sev.WARN] then
        table.insert(out, "%#LSPWarn# " .. counts[sev.WARN] .. Spacer(1))
    end
    if counts[sev.INFO] then
        table.insert(out, "%#LSPInfo# " .. counts[sev.INFO] .. Spacer(1))
    end
    if counts[sev.HINT] then
        table.insert(out, "%#LSPHint# " .. counts[sev.HINT] .. Spacer(1))
    end
    return table.concat(out)
end

function Status.CursorPos()
    return " %#CursorPos#%l:%c|%p%% "
end

-- Render statusline
function _G.Statusline()
    return table.concat({
        Status.Mode(),
        Status.GitLspContext(),
        Status.GitSigns(),
        Spacer(2),
        Align(),
        Status.Diagnostics(),
        Status.LspStatus(),
        Status.CursorPos(),
        Truncate(),
    })
end

vim.o.statusline = "%!v:lua.Statusline()"

local group = vim.api.nvim_create_augroup("StatusLineRefresh", { clear = true })

vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach", "DiagnosticChanged" }, {
    desc = "Show bash lsp right after opening the file",
    group = group,
    callback = function()
        vim.schedule(function()
            vim.cmd.redrawstatus()
        end)
    end,
})

vim.api.nvim_create_autocmd("User", {
    desc = "Show Gitsigns right after opening a file",
    pattern = "GitSignsUpdate",
    group = group,
    callback = function()
        vim.schedule(function()
            vim.cmd.redrawstatus()
        end)
    end,
})
