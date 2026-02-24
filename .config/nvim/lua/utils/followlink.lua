local M = {}

-- Set your notes root here
M.notes_root = vim.fn.expand("~/hub/src/mdnotes")

-- Main function: follow markdown link under cursor
function M.follow_markdown_link()
    local line = vim.api.nvim_get_current_line()
    local file = line:match("%((.-)%)") -- match (file.md)

    if not file or file == "" then
        vim.cmd("normal! gf")
        return
    end

    -- Always resolve relative to notes_root
    local full_path = M.notes_root .. "/" .. file
    full_path = vim.fn.fnamemodify(full_path, ":p") -- normalize

    if vim.fn.filereadable(full_path) == 1 then
        vim.cmd.edit(vim.fn.fnameescape(full_path))
    else
        vim.notify("File does not exist: " .. full_path, vim.log.levels.WARN)
    end
end

return M
