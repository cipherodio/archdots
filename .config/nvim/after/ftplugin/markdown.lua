local km = require("utils.keymaps")
local opt = vim.opt_local

-- opt.conceallevel = 2
-- opt.concealcursor = ""
opt.spell = true
opt.textwidth = 72
opt.linebreak = true

km.nmap("<leader>tc", function()
    local cl = vim.api.nvim_get_option_value("conceallevel", { scope = "local" })

    if cl == 0 then
        vim.api.nvim_set_option_value("conceallevel", 2, { scope = "local" })
        vim.api.nvim_set_option_value("concealcursor", "", { scope = "local" })
    else
        vim.api.nvim_set_option_value("conceallevel", 0, { scope = "local" })
    end
end, { desc = "Toggle conceal" })

-- km.nmap("<Tab>", "za", { desc = "Toggle fold (markdown only)" })

-- New: Markdown TOC generator keybind
-- km.nmap("<leader>mt", function()
--     -- Run markdown-toc for current buffer
--     local filename = vim.api.nvim_buf_get_name(0)
--     vim.cmd("silent !markdown-toc --indent '    ' -i " .. filename .. " --bullets -")
--     vim.cmd("edit!") -- reload file to reflect TOC changes
-- end, { desc = "Generate Markdown TOC" })

-- Async Markdown TOC generator
km.nmap("<leader>mt", function()
    local buf = 0
    local filename = vim.api.nvim_buf_get_name(buf)
    local row, col = unpack(vim.api.nvim_win_get_cursor(0)) -- save cursor

    -- Run markdown-toc asynchronously
    vim.fn.jobstart(
        { "markdown-toc", "--indent", "    ", "-i", filename, "--bullets", "-" },
        {
            on_exit = function(_, exit_code)
                if exit_code ~= 0 then
                    vim.schedule(function()
                        vim.notify("markdown-toc failed", vim.log.levels.ERROR)
                    end)
                    return
                end

                -- Reload buffer safely on main thread
                vim.schedule(function()
                    vim.cmd("edit!") -- reload file to reflect TOC changes
                    vim.api.nvim_win_set_cursor(0, { row, col }) -- restore cursor
                    vim.notify("TOC updated", vim.log.levels.INFO)
                end)
            end,
        }
    )
end, { desc = "Generate Markdown TOC (async, 4-space bullets)" })
