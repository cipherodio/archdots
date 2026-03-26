local ui = require("utils.colors")

local function Spacer(n)
    return "%#SpacerHL#" .. string.rep(" ", n or 1)
end

local function Align()
    return "%="
end

local function apply_winbar_hl()
    local hl = vim.api.nvim_set_hl
    hl(0, "SpacerHL", { bg = ui.c00 })
    hl(0, "WinbarFilename", { fg = ui.c08, bg = ui.c00 })
    hl(0, "WinbarModified", { fg = ui.c01, bg = ui.c00 })
    hl(0, "WinbarSearch", { fg = ui.c08, bg = ui.c00 })
end

apply_winbar_hl()
vim.api.nvim_create_autocmd("ColorScheme", { callback = apply_winbar_hl })

local Status = {}

function Status.WinbarFile()
    local winid = vim.g.statusline_winid or 0
    local bufnr = vim.api.nvim_win_get_buf(winid)
    local name = vim.api.nvim_buf_get_name(bufnr)
    local full_path = (name == "") and "[No Name]" or vim.fn.fnamemodify(name, ":~")
    local mod = vim.bo[bufnr].modified and " %#WinbarModified#[+]" or ""
    return Spacer(1) .. "%#WinbarFilename# " .. full_path .. mod
end

function Status.SearchCount()
    if vim.v.hlsearch == 0 then
        return ""
    end
    local ok, s_count = pcall(vim.fn.searchcount, { recompute = 1, maxcount = 999 })
    if not ok or not s_count or s_count.total == nil or s_count.total == 0 then
        return ""
    end
    return "%#WinbarSearch#["
        .. s_count.current
        .. "/"
        .. s_count.total
        .. "]"
        .. Spacer(1)
end

-- Render winbar
_G.render_winbar = function()
    local winid = vim.g.statusline_winid or 0
    local bufnr = vim.api.nvim_win_get_buf(winid)
    local ft = vim.bo[bufnr].filetype
    local bt = vim.bo[bufnr].buftype
    local excluded = { oil = true, fzf = true, notify = true, lazy = true }

    if excluded[ft] or bt ~= "" then
        return ""
    end

    return table.concat({
        Status.WinbarFile(),
        Align(),
        Status.SearchCount(),
    })
end

local group = vim.api.nvim_create_augroup("WinbarRefresh", { clear = true })
vim.api.nvim_create_autocmd({ "CursorMoved", "CmdlineChanged" }, {
    desc = "Refresh winbar",
    group = group,
    callback = function()
        if vim.v.hlsearch == 1 then
            vim.cmd.redrawstatus()
        end
    end,
})

vim.opt.winbar = "%!v:lua.render_winbar()"
