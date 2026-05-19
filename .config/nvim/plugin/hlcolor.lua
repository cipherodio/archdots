vim.pack.add({
    { src = "https://github.com/brenoprata10/nvim-highlight-colors" },
}, { confirm = false })

local h = require("nvim-highlight-colors")
local k = require("utils.keyhelper")

-- h.setup({
--     render = "virtual",
--     virtual_symbol = "󰝤",
--     virtual_symbol_position = "eol",
-- })

k("n", "<leader>ah", function()
    h.toggle()
end, { desc = "Toggle: color highlight" })
