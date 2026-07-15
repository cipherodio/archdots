local M = {}

local function file_path(buf)
    local path = vim.api.nvim_buf_get_name(buf)

    if path == "" then
        path = "[No Name]"
    else
        path = vim.fn.fnamemodify(path, ":~")
    end

    local modified = vim.bo[buf].modified

    if modified then
        return "📁 " .. path .. " [+]"
    end

    return "📁 " .. path
end

local function search_count()
    if vim.v.hlsearch == 0 then
        return ""
    end

    local ok, result = pcall(vim.fn.searchcount, {
        recompute = 1,
        maxcount = 999,
    })

    if not ok or not result.total or result.total == 0 then
        return ""
    end

    return ("%d/%d"):format(result.current, result.total)
end

function M.winbar()
    local buf = vim.api.nvim_get_current_buf()
    local left = file_path(buf)
    local right = search_count()

    return (" %s%%=%s "):format(left, right)
end

vim.o.winbar = "%{%v:lua.require'core.winbar'.winbar()%}"

return M
