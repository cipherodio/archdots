vim.pack.add({
    { src = "https://github.com/Kamyil/markdown-agenda.nvim" },
}, { confirm = false })

local a = require("markdown-agenda")

a.setup({
    directory = "~/hub/src/mdnotes",
    recursive = true,
    date_format = "%Y-%m-%d",
    help = false,
    help_separator = false,
    border = "single",
    title = false,
    -- keymaps = { open = false },
    keymaps = {
        open = "<leader>ma",
    },
    calendar = {
        enabled = true,
        months_to_show = 3,
        position = "top",
        grid_columns = 3,
        week_start = "monday",
    },
})
