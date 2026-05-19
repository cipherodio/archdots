local M = {}

-- Helper: current git branch
local function git_branch()
    local gitsigns = vim.b.gitsigns_head
    if gitsigns and gitsigns ~= "" then
        -- return (" %s"):format(gitsigns)
        return ("🍀 %s"):format(gitsigns)
    end
    return ""
end

-- Helper: gitsigns diff stats
local function git_diff()
    local gs = vim.b.gitsigns_status_dict
    if not gs then
        return ""
    end

    local parts = {}

    if gs.added and gs.added > 0 then
        table.insert(parts, ("+%d"):format(gs.added))
    end

    if gs.changed and gs.changed > 0 then
        table.insert(parts, ("~%d"):format(gs.changed))
    end

    if gs.removed and gs.removed > 0 then
        table.insert(parts, ("-%d"):format(gs.removed))
    end

    return table.concat(parts, " ")
end

-- Helper: active LSP names
local function lsp_status()
    local clients = vim.lsp.get_clients({
        bufnr = 0,
    })

    if #clients == 0 then
        return ""
    end

    return "LSP"
end

-- Cursor
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
    local left = table.concat({
        git_branch(),
        git_diff(),
    }, " ")

    local right = table.concat({
        vim.ui.progress_status(),
        vim.diagnostic.status(),
        lsp_status(),
        cursor_position(),
    }, "  ")

    return table.concat({
        " ",
        left,
        "%=",
        right,
        " ",
    })
end

vim.o.statusline = "%!v:lua.require'core.statusline'.statusline()"

local group = vim.api.nvim_create_augroup("StatusLineRefresh", { clear = true })

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

return M
