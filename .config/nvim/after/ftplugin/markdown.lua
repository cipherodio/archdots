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

-- Async Markdown TOC generator
-- km.nmap("<leader>mt", function()
--     local buf = 0
--     local filename = vim.api.nvim_buf_get_name(buf)
--     local row, col = unpack(vim.api.nvim_win_get_cursor(0))
--
--     vim.fn.jobstart(
--         { "markdown-toc", "--indent", "    ", "-i", filename, "--bullets", "-" },
--         {
--             on_exit = function(_, exit_code)
--                 if exit_code ~= 0 then
--                     vim.schedule(function()
--                         vim.notify("markdown-toc failed", vim.log.levels.ERROR)
--                     end)
--                     return
--                 end
--
--                 vim.schedule(function()
--                     vim.cmd("edit!")
--                     vim.api.nvim_win_set_cursor(0, { row, col })
--                     vim.notify("TOC updated", vim.log.levels.INFO)
--                 end)
--             end,
--         }
--     )
-- end, { desc = "Generate Markdown TOC (async, 4-space bullets)" })
