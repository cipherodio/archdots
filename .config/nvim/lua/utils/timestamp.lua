local M = {}

-- Helpers for auto timestamp file on save
local function is_modifiable_and_changed(bufnr)
    return vim.bo[bufnr].modifiable and vim.bo[bufnr].modified
end

local function should_skip(bufnr)
    if vim.bo[bufnr].buftype ~= "" then
        return true
    end

    if vim.bo[bufnr].filetype == "gitcommit" then
        return true
    end

    return false
end

local function get_comment_format(filetype)
    -- Normalize compound filetypes (e.g. javascript.jsx, typescriptreact)
    local ft = filetype:match("^[^.]+") or filetype

    local prefixes = {
        lua = "--",
        python = "#",
        sh = "#",
        bash = "#",
        zsh = "#",
        javascript = "//",
        typescript = "//",
        c = "//",
        cpp = "//",
        java = "//",
        go = "//",
        toml = "#",
        tmux = "#",
        html = "<!--",
        css = "/*",
    }

    local prefix = prefixes[ft]
    if not prefix then
        return nil
    end

    local suffix = ""
    if ft == "html" then
        suffix = " -->"
    elseif ft == "css" then
        suffix = " */"
    end

    return prefix, suffix
end

-- Public API
function M.update(bufnr)
    if should_skip(bufnr) or not is_modifiable_and_changed(bufnr) then
        return
    end

    local prefix, suffix = get_comment_format(vim.bo[bufnr].filetype)
    if not prefix then
        return
    end

    local time = os.date("%a, %d %b %Y %I:%M:%S %p")
    local comment = string.format("%s Last Modified: %s%s", prefix, time, suffix)

    local last = vim.api.nvim_buf_line_count(bufnr)
    local line = vim.api.nvim_buf_get_lines(bufnr, last - 1, last, false)[1] or ""

    local prefix_pat = vim.pesc(prefix)

    if line:match("^%s*" .. prefix_pat .. "%s+Last Modified:") then
        vim.api.nvim_buf_set_lines(bufnr, last - 1, last, false, { comment })
    else
        vim.api.nvim_buf_set_lines(bufnr, last, last, false, { "", comment })
    end
end

return M
