vim.pack.add({
    { src = "https://github.com/folke/todo-comments.nvim" },
}, { confirm = false })

local k = require("utils.keyhelper")
local t = require("todo-comments")

t.setup({
    signs = false,
})

k("n", "<C-]>", function()
    t.jump_next()
end, {
    desc = "Jump to next todo comment",
})

k("n", "<C-[>", function()
    t.jump_prev()
end, {
    desc = "Jump to previous todo comment",
})

k("n", "<leader>fT", "<cmd>TodoFzfLua<cr>", {
    desc = "Todo: comments",
})
