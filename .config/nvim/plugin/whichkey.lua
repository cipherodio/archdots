vim.pack.add({
    { src = "https://github.com/folke/which-key.nvim" },
}, { confirm = false })

local wk = require("which-key")

wk.setup({
    preset = "classic",
    spec = {
        {
            mode = { "n", "v" },
            { "<leader>a", group = "action" },
            { "<leader>w", group = "write/save" },
            { "<leader>q", group = "quit" },
            { "<leader>y", group = "yank" },
            { "<leader>f", group = "find" },
            { "<leader>g", group = "git" },
            { "<leader>b", group = "buffer" },
            { "<leader>e", group = "explorer" },
            { "<leader>l", group = "lsp" },
            { "<leader>m", group = "markdown" },
            { "<leader>p", group = "plugin" },
            { "<leader>s", group = "spelling" },
            { "<leader>t", group = "treesitter" },
        },
    },
    win = {
        no_overlap = false,
        border = "single",
        title = false,
    },
    icons = {
        breadcrumb = "»",
        separator = "•",
        mappings = false,
        keys = {
            Tab = "⭳",
        },
    },
    show_help = false,
    show_keys = false,
})
