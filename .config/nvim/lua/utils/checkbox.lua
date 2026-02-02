local M = {}

-- Toggle checkbox state for markdown:
-- [ ] -> [x] -> [-] -> [ ]
function M.toggle()
    if vim.bo.filetype ~= "markdown" then
        return
    end

    local line = vim.api.nvim_get_current_line()
    local new_line

    if line:find("%[ %]") then
        new_line = line:gsub("%[ %]", "[x]", 1)
        vim.api.nvim_set_current_line(new_line)
        return
    end

    if line:find("%[x%]") then
        new_line = line:gsub("%[x%]", "[-]", 1)
        vim.api.nvim_set_current_line(new_line)
        return
    end

    if line:find("%[%-%]") then
        new_line = line:gsub("%[%-%]", "[ ]", 1)
        vim.api.nvim_set_current_line(new_line)
        return
    end
end

return M
