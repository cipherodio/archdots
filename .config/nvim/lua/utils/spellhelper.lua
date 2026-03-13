local M = {}

-- Add word with zg as lowercase works with visual mode
function M.spell_add_lower(count)
    return function()
        local word
        local mode = vim.api.nvim_get_mode().mode
        local prefix = (count and count > 1) and tostring(count) or ""

        if mode:find("[vV]") then
            local saved_reg = vim.fn.getreg("v")
            vim.cmd('normal! "vy')
            word = vim.fn.getreg("v")
            vim.fn.setreg("v", saved_reg)
        else
            word = vim.fn.expand("<cword>"):gsub("[%_%*%~%`]", "")
        end
        if word and word ~= "" then
            local lower_word = vim.trim(word):lower()
            vim.cmd(prefix .. "spellgood " .. lower_word)
            print(
                "   Added lowercase ("
                    .. (prefix == "" and "tl" or "en")
                    .. "): "
                    .. lower_word
            )
        end
    end
end

-- Permanently delete all "#" commented lines in your spell .add files
function M.clean_spell_files()
    local spell_dir = vim.fn.stdpath("config") .. "/spell/"
    local files = vim.fn.glob(spell_dir .. "*.add", false, true)

    if #files == 0 then
        print("No .add files found.")
        return
    end
    for _, file in ipairs(files) do
        local lines = {}
        local f_in = io.open(file, "r")
        if f_in then
            for line in f_in:lines() do
                if not line:match("^%s*#") and line:match("%S") then
                    table.insert(lines, line)
                end
            end
            f_in:close()

            local f_out = io.open(file, "w")
            if f_out then
                f_out:write(table.concat(lines, "\n") .. "\n")
                f_out:close()
            end
        end
    end
    vim.cmd("silent! spellreall")
    print("󰃢 Dictionaries cleaned!")
end

-- Undo word with underscore surrounded by _, ex: _word_
-- supports both tagalog/english & handles visual and normal mode
function M.smart_spell(count)
    return function()
        local word
        local mode = vim.api.nvim_get_mode().mode
        local prefix = (count and count > 1) and tostring(count) or ""

        if mode:find("[vV]") then
            local saved_reg = vim.fn.getreg("v")
            vim.cmd('normal! "vy')
            word = vim.fn.getreg("v")
            vim.fn.setreg("v", saved_reg)
            vim.api.nvim_feedkeys(
                vim.api.nvim_replace_termcodes("<Esc>", true, false, true),
                "n",
                false
            )
        else
            word = vim.fn.expand("<cword>")
        end
        word = word:gsub("[%_%*%~%`]", "")
        if word and word ~= "" then
            local lower_word = vim.trim(word):lower()
            vim.cmd(prefix .. "spellundo " .. lower_word)
            print(
                "   Removed (" .. (prefix == "" and "tl" or "en") .. "): " .. lower_word
            )
        end
    end
end

-- Misspelled word list with previewer
function M.fzf_spell_all()
    if not vim.wo.spell then
        return print("   Spell check is OFF")
    end

    local entries = {}
    local bufnr = vim.api.nvim_get_current_buf()
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
    local lang = (vim.bo.spelllang or "en"):gsub(",", "/")
    local start_line = 1

    if lines[1] == "---" then
        for i = 2, #lines do
            if lines[i] == "---" then
                start_line = i + 1
                break
            end
        end
    end
    for i = start_line, #lines do
        local line_text = lines[i]
        local col_offset = 0
        while #line_text > 0 do
            local res = vim.fn.spellbadword(line_text)
            local word = res[1]
            if not word or word == "" then
                break
            end
            local s, e = line_text:find(word, 1, true)
            if not s then
                break
            end
            table.insert(entries, string.format("%d:%d: %s", i, col_offset + s, word))
            line_text = line_text:sub(e + 1)
            col_offset = col_offset + e
        end
    end
    if #entries == 0 then
        return print("   No " .. lang .. " misspellings!")
    end
    local preview_cmd = "word={3..}; sed -n '{1}p' "
        .. vim.fn.shellescape(fname)
        .. ' | sed "s/$word/\\x1b[31m&\\x1b[0m/g"'
    ---@type table
    local opts = {
        prompt = string.format("Spell (%s)> ", lang),
        winopts = {
            height = 0.45,
            width = 0.90,
            row = 0.40,
            preview = {
                scrollbar = false,
                hidden = false,
            },
        },
        fzf_opts = {
            ["--delimiter"] = ":",
            ["--preview"] = preview_cmd,
            ["--preview-window"] = "down:50%,wrap,nohidden,noinfo",
        },
        actions = {
            ["default"] = function(selected)
                if not selected or #selected == 0 then
                    return
                end
                local sel = selected[1]
                local lnum, col = sel:match("(%d+):(%d+):")
                if lnum and col then
                    vim.api.nvim_win_set_cursor(0, { tonumber(lnum), tonumber(col) - 1 })
                    vim.cmd("normal! zz")
                end
            end,
        },
    }
    require("fzf-lua").fzf_exec(entries, opts)
end

-- Total: Reading time | word count | wrong spelled words
function M.report_stats()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local word_count = 0
    local spell_count = 0
    local spell_enabled = vim.wo.spell
    local start_line = 1
    local skip_block = false

    if lines[1] == "---" then
        for i = 2, #lines do
            if lines[i] == "---" then
                start_line = i + 1
                break
            end
        end
    end
    for i = start_line, #lines do
        local line = lines[i]
        if line:find("<!%-%- toc %-%->") then
            skip_block = true
        end
        if not skip_block then
            for _ in line:gmatch("%S+") do
                word_count = word_count + 1
            end
            if spell_enabled and #line > 0 then
                local temp = line
                while #temp > 0 do
                    local spell_res = vim.fn.spellbadword(temp)
                    local word = spell_res[1]
                    if not word or word == "" then
                        break
                    end
                    spell_count = spell_count + 1
                    local _, e = temp:find(word, 1, true)
                    temp = temp:sub((e or #word) + 1)
                end
            end
        end
        if line:find("<!%-%- tocstop %-%->") then
            skip_block = false
        end
    end
    local reading_time = math.ceil(word_count / 110)
    local time_label = reading_time == 1 and " minute" or " minutes"
    local spell_str = spell_enabled and (" | 󰖭 :" .. spell_count .. " misspelled")
        or " | 󰍉 Spell: OFF"
    print(
        " 󰅐 :"
            .. reading_time
            .. time_label
            .. " | 󰈭 :"
            .. word_count
            .. " words"
            .. spell_str
    )
end

return M
