local M = {}

-- Open markdown notes
function M.open_agenda()
    vim.cmd.edit(vim.fn.expand("~/hub/src/mdnotes/agenda.md"))
end

-- Move current word as you type when reach the max textwidth
function M.smart_textwidth()
    local textwidth = vim.bo.textwidth

    if textwidth <= 0 or vim.fn.virtcol(".") < textwidth then
        return
    end

    local cursor = vim.api.nvim_win_get_cursor(0)
    local row = cursor[1]
    local col = cursor[2]
    local line = vim.api.nvim_get_current_line()
    local before_cursor = line:sub(1, col + 1)
    local word_start = before_cursor:find("%S+$")

    -- Nothing to move, or the word already starts the line.
    if not word_start or word_start == 1 then
        return
    end

    local before_word = before_cursor:sub(1, word_start - 1)
    local whitespace_start = before_word:find("%s+$")

    if not whitespace_start then
        return
    end

    -- Replace the whitespace before the current word with a newline.
    vim.api.nvim_buf_set_text(
        0,
        row - 1,
        whitespace_start - 1,
        row - 1,
        word_start - 1,
        { "", "" }
    )

    -- Continue typing at the same position on the new line.
    vim.api.nvim_win_set_cursor(0, { row + 1, col - word_start + 1 })

    local view = vim.fn.winsaveview()

    view.leftcol = 0
    vim.fn.winrestview(view)
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
