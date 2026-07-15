local M = {}

local colors = require("fn.colors")
local group = vim.api.nvim_create_augroup("StatusLine", { clear = true })

-- Join non-empty statusline sections
local function join(parts, separator)
    local result = {}

    for _, part in ipairs(parts) do
        if part and part ~= "" then
            result[#result + 1] = part
        end
    end

    return table.concat(result, separator)
end

-- Highlights
local function set_highlights()
    local palette = colors.current()

    vim.api.nvim_set_hl(0, "StatusLineGitAdded", { fg = palette.c10 })
    vim.api.nvim_set_hl(0, "StatusLineGitChanged", { fg = palette.c11 })
    vim.api.nvim_set_hl(0, "StatusLineGitDeleted", { fg = palette.c09 })
end

set_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
    desc = "Restore custom statusline highlights",
    group = group,
    callback = set_highlights,
})

-- Current git branch
local function git_branch()
    local branch = vim.b.gitsigns_head

    if branch and branch ~= "" then
        return ("🍀 %s"):format(branch)
    end

    return ""
end

-- Gitsigns diff stats
local function git_diff()
    local status = vim.b.gitsigns_status_dict

    if not status then
        return ""
    end

    local parts = {}

    if status.added and status.added > 0 then
        parts[#parts + 1] = ("%%#StatusLineGitAdded#+%d%%*"):format(status.added)
    end

    if status.changed and status.changed > 0 then
        parts[#parts + 1] = ("%%#StatusLineGitChanged#~%d%%*"):format(status.changed)
    end

    if status.removed and status.removed > 0 then
        parts[#parts + 1] = ("%%#StatusLineGitDeleted#-%d%%*"):format(status.removed)
    end

    return table.concat(parts, " ")
end

-- LSP status
local function lsp_status()
    local clients = vim.lsp.get_clients({
        bufnr = 0,
    })

    if #clients == 0 then
        return ""
    end

    return "LSP"
end

-- Cursor position
local function cursor_position()
    local line = vim.fn.line(".")
    local col = vim.fn.col(".")
    local total = vim.fn.line("$")
    local percent

    if line == 1 then
        percent = "Top"
    elseif line == total then
        percent = "End"
    else
        percent = ("%d%%%%"):format(math.floor((line / total) * 100))
    end

    return ("%d:%d | %s"):format(line, col, percent)
end

-- Main statusline
function M.statusline()
    local left = join({ git_branch(), git_diff() }, " ")
    local right = join({
        vim.ui.progress_status(),
        vim.diagnostic.status(),
        lsp_status(),
        cursor_position(),
    }, "  ")

    return table.concat({ " ", left, "%=", right, " " })
end

vim.o.statusline = "%!v:lua.require'core.statusline'.statusline()"

vim.api.nvim_create_autocmd("User", {
    desc = "Refresh statusline after Gitsigns updates",
    pattern = "GitSignsUpdate",
    group = group,
    callback = function()
        vim.schedule(function()
            vim.cmd.redrawstatus()
        end)
    end,
})

return M
