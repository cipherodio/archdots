local M = {}

-- Open markdown notes
function M.open_agenda()
    vim.cmd.edit(vim.fn.expand("~/hub/src/mdnotes/agenda.md"))
end

-- Snap back to left when textwidth is reach
function M.smart_snap()
    local curr_lnum = vim.fn.line(".")
    local last_lnum = vim.b.last_lnum or curr_lnum

    if curr_lnum > last_lnum then
        local view = vim.fn.winsaveview()
        if view.leftcol > 0 then
            view.leftcol = 0
            vim.fn.winrestview(view)
        end
    elseif curr_lnum < last_lnum then
        vim.b.last_lnum = curr_lnum
    end
    vim.b.last_lnum = curr_lnum
end

-- Checkbox toggle
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
function M.new_checkbox()
    local line = vim.api.nvim_get_current_line()
    local indent = line:match("^%s*") or ""
    local keys =
        vim.api.nvim_replace_termcodes("<Esc>o" .. indent .. "- [ ] ", true, false, true)
    vim.api.nvim_feedkeys(keys, "n", true)
end

-- Smart follow link (gf)
function M.follow_markdown_link()
    local notes_root = vim.fn.expand("~/hub/src/mdnotes")
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
        local root = notes_root:gsub("/$", "")
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

-- Toggle markdown conceal
function M.toggle_conceal()
    local cl = vim.api.nvim_get_option_value("conceallevel", { scope = "local" })

    if cl == 0 then
        vim.api.nvim_set_option_value("conceallevel", 2, { scope = "local" })
        vim.api.nvim_set_option_value("concealcursor", "", { scope = "local" })
    else
        vim.api.nvim_set_option_value("conceallevel", 0, { scope = "local" })
    end
    local state = (cl == 0 and "ON" or "OFF")
    print("Conceal: " .. state)
end

return M
