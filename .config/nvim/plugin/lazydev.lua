vim.pack.add({
    { src = "https://github.com/folke/lazydev.nvim" },
}, { confirm = false })

local l = require("lazydev")

l.setup({
    library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
})
