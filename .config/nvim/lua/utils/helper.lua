local M = {}

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

return M
