vim.pack.add({
    { src = "https://github.com/brenoprata10/nvim-highlight-colors" },
}, { confirm = false })

-- Keymaps
local map = vim.keymap.set

map("n", "<leader>ah", function()
    require("nvim-highlight-colors").toggle()
end, { desc = "Toggle: color highlight" })
