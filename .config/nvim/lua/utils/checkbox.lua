local M = {}

-- Togge Markdown checkbox
-- Cycle: [ ] -> [x] -> [-] -> [ ]
function M.toggle()
    local line = vim.api.nvim_get_current_line()
    local new_line
    if line:find("%[ %]") then
        new_line = line:gsub("%[ %]", "[x]", 1)
    elseif line:find("%[x%]") then
        new_line = line:gsub("%[x%]", "[-]", 1)
    elseif line:find("%[%-%]") then
        new_line = line:gsub("%[%-%]", "[ ]", 1)
    elseif line:find("^%s*%- ") then
        new_line = line:gsub("%- ", "- [ ] ", 1)
    end
    if new_line then
        vim.api.nvim_set_current_line(new_line)
    end
end

-- New checkbox line
-- Purpose: Smart continuation of task list in both Normal & Insert mode.
function M.new_checkbox()
    local line = vim.api.nvim_get_current_line()
    local indent = line:match("^%s*") or ""
    local keys =
        vim.api.nvim_replace_termcodes("<Esc>o" .. indent .. "- [ ] ", true, false, true)
    vim.api.nvim_feedkeys(keys, "n", true)
end

return M
