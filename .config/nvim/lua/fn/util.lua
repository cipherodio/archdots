local M = {}

-- Update plugin
function M.plugin_stats()
    -- vim.pack.update(nil, { offline = true })
    vim.pack.update()
end

-- Delete plugin
function M.plugin_delete(plugin)
    vim.pack.del({ plugin })
    vim.pack.update()
end

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

-- Smart quit with q
function M.smart_quit()
    local wins = vim.api.nvim_list_wins()

    if #wins > 1 then
        vim.cmd("close")
    else
        vim.cmd("quit")
    end
end

-- Close md-agenda buffer safely
function M.close_md_agenda(buf)
    if buf and vim.api.nvim_buf_is_valid(buf) then
        vim.cmd("bd! " .. buf)
    else
        vim.cmd("bd!")
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

-- Create/Open file with path completion (defaults to current file's directory)
function M.create_and_open()
    local input = vim.fn.input("New file: ", "", "file")

    if input == "" then
        return
    end
    if not (input:match("^/") or input:match("^~")) then
        input = vim.fn.expand("%:p:h") .. "/" .. input
    end
    vim.cmd("edit " .. input)
end

-- Create file on disk in current directory
function M.create_on_disk()
    local name = vim.fn.input("New file (Touch): ")
    if name ~= "" then
        local path = vim.fn.expand("%:p:h") .. "/" .. name
        vim.fn.system({ "touch", path })
        vim.cmd("redraw")
        print("Created: " .. name)
    end
end

-- Check current deepseek balance
function M.check_deepseek_balance()
    local api_key = os.getenv("DEEPSEEK_API_KEY") or os.getenv("LLM_KEY")
    if not api_key or api_key == "" then
        print("Error: No API Key found.")
        return
    end
    print("Checking balance... 󰔟")
    local cmd = string.format(
        "curl -s -X GET 'https://api.deepseek.com/user/balance' "
            .. "-H 'Authorization: Bearer %s' | "
            .. 'jq -r \'.balance_infos[0] | "󰇁" + .total_balance + " " + .currency\'',
        api_key
    )
    local output = {}

    vim.fn.jobstart({ "sh", "-c", cmd }, {
        stdout_buffered = true,
        on_stdout = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        table.insert(output, line)
                    end
                end
            end
        end,
        on_exit = function(_, code)
            vim.schedule(function()
                local result =
                    table.concat(output, " "):gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")
                if code == 0 and result ~= "" and result ~= "null" then
                    print(result)
                else
                    print("Failed to fetch balance. Check your API key or credits.")
                end
            end)
        end,
    })
end

return M
