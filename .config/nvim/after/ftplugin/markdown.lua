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

-- Last Modified: Wed, 07 Jan 2026 02:44:14 AM
