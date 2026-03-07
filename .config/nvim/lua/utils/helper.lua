local M = {}

-- Save and restore cursor position
function M.restore_cursor()
    if vim.bo.buftype ~= "" or vim.wo.diff then
        return
    end
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local line_count = vim.api.nvim_buf_line_count(0)
    if mark[1] > 1 and mark[1] <= line_count then
        if vim.api.nvim_win_get_cursor(0)[1] == 1 then
            vim.api.nvim_win_set_cursor(0, mark)
            vim.cmd("normal! zz")
        end
    end
end

-- Clear highlight search with Escape
function M.smart_esc()
    if vim.v.hlsearch == 1 then
        vim.cmd("nohlsearch")
        vim.cmd("redrawstatus")
    end
    return "<esc>"
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

-- Smart quit with q
function M.smart_quit()
    local wins = vim.api.nvim_list_wins()

    if #wins > 1 then
        vim.cmd("close")
    else
        vim.cmd("quit")
    end
end

-- Smart Navigation
function M.smart_j()
    return vim.v.count == 0 and "gj" or "j"
end

function M.smart_k()
    return vim.v.count == 0 and "gk" or "k"
end

-- Smart Search Navigation
function M.smart_n()
    return (vim.v.searchforward == 1 and "n" or "N") .. "zv"
end

function M.smart_N()
    return (vim.v.searchforward == 1 and "N" or "n") .. "zv"
end

-- Smart dd
function M.smart_dd()
    if vim.api.nvim_get_current_line():match("^%s*$") then
        return '"_dd'
    end
    return "dd"
end

-- Open my markdown notes
function M.open_agenda()
    vim.cmd.edit(vim.fn.expand("~/hub/src/mdnotes/agenda.md"))
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

-- Undo word with underscore surrounding it _word_
function M.smart_spell(action, count)
    return function()
        local word = vim.fn.expand("<cword>"):gsub("[%_%*%~%`]", "")

        if word == "" then
            return
        end
        local prefix = (count and count > 1) and tostring(count) or ""
        vim.cmd(prefix .. "spell" .. action .. " " .. word)
        print("󰕍 Removed '" .. word .. "'")
    end
end

-- Total: Reading time | word count | wrong spelled words
function M.report_stats()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local word_count = 0
    local spell_count = 0
    local spell_enabled = vim.wo.spell

    for _, line in ipairs(lines) do
        for _ in line:gmatch("%S+") do
            word_count = word_count + 1
        end
        if spell_enabled then
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
    local reading_time = math.ceil(word_count / 225)
    local time_label = reading_time == 1 and " minute" or " minutes"
    local spell_str = spell_enabled and (" | ❌:" .. spell_count .. " misspelled")
        or " | 🔍 Spell: OFF"

    print(
        "󰅐 :"
            .. reading_time
            .. time_label
            .. " | 󰈭 :"
            .. word_count
            .. " words"
            .. spell_str
    )
end

return M
