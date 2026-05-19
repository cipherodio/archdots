vim.pack.add({
    { src = "https://github.com/windwp/nvim-autopairs" },
}, { confirm = false })

local a = require("nvim-autopairs")

a.setup({
    disable_filetype = { "text" },
    check_ts = true,
})
