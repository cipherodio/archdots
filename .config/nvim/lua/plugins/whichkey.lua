return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        spec = {
            {
                mode = { "n", "v" },
                { "<leader>a", group = "action" },
                { "<leader>g", group = "git" },
                { "<leader>f", group = "find" },
                { "<leader>l", group = "lsp" },
                { "<leader>m", group = "markdown" },
                { "<leader>d", group = "debugger" },
                { "<leader>t", group = "treesitter" },
                { "<leader><tab>", group = "buffers" },
            },
        },
        win = {
            no_overlap = true,
            border = "single",
            title = false,
        },
        layout = {
            spacing = 1,
            align = "center",
        },
        icons = {
            rules = false,
            breadcrumb = "»",
            separator = "•",
            group = "+",
            keys = {
                Tab = "⭳",
            },
        },
        show_help = false,
        show_keys = false,
    },
}
