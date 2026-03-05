local M = {}

M.notes_root = vim.fn.expand("~/hub/src/mdnotes")

---Follow the [link.md] under the cursor or on the current line
function M.follow_markdown_link()
    local line = vim.api.nvim_get_current_line()
    local file = line:match("%((/[^)]+%.md)%)") or line:match("%(([^)]+%.md)%)")

    if not file or file == "" then
        local ok = pcall(function()
            vim.cmd("normal! gf")
        end)
        if not ok then
            print("No link or file found on this line")
        end
        return
    end

    local full_path
    if file:sub(1, 1) == "/" then
        local root = M.notes_root:gsub("/$", "")
        full_path = root .. file
    else
        full_path = vim.fn.expand("%:p:h") .. "/" .. file
    end

    full_path = vim.fn.fnamemodify(full_path, ":p")
    if vim.fn.filereadable(full_path) == 1 then
        vim.cmd("normal! m'")
        vim.cmd.edit(vim.fn.fnameescape(full_path))
    else
        local ok = pcall(function()
            vim.cmd("normal! gf")
        end)
        if not ok then
            vim.notify("Note not found: " .. full_path, vim.log.levels.WARN)
        end
    end
end

return M
