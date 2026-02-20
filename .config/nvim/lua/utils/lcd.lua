local M = {}

local uv = vim.loop

-- Configure roots here (only once)
local roots = {
    "~/hub/src/mdnotes",
    "~/hub/src/podcast",
}

-- Resolve roots to real paths
local resolved_roots = {}
for _, root in ipairs(roots) do
    local real = uv.fs_realpath(vim.fn.expand(root))
    if real then
        table.insert(resolved_roots, real)
    end
end

local function is_normal_buffer(bufnr)
    return vim.bo[bufnr].buftype == ""
end

local function starts_with(path, root)
    return path:sub(1, #root) == root
end

function M.maybe_lcd(bufnr)
    if not is_normal_buffer(bufnr) then
        return
    end

    local path = vim.api.nvim_buf_get_name(bufnr)
    if path == "" then
        return
    end

    path = uv.fs_realpath(path) or path

    for _, root in ipairs(resolved_roots) do
        if starts_with(path, root) then
            vim.cmd.lcd(vim.fn.fnamemodify(path, ":h"))
            return
        end
    end
end

return M
