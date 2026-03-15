return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    ---@module "which-key"
    ---@type wk.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
        preset = "classic",
        spec = {
            {
                mode = { "n", "v" },
                { "<leader>a", group = "action" },
                { "<leader>e", group = "explorer" },
                { "<leader>w", group = "write/save" },
                { "<leader>q", group = "quit" },
                { "<leader>g", group = "git" },
                { "<leader>f", group = "find" },
                { "<leader>l", group = "lsp" },
                { "<leader>m", group = "markdown" },
                { "<leader>d", group = "debugger" },
                { "<leader>s", group = "spelling" },
                { "<leader>t", group = "treesitter" },
                { "<leader>b", group = "buffer" },
                { "<leader>y", group = "yank" },
            },
        },
        win = {
            no_overlap = false,
            border = "single",
            padding = { 1, 2 },
            title = false,
        },
        layout = {
            spacing = 3,
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
        delay = 200,
        plugins = {
            spelling = {
                enabled = true,
                suggestions = 15,
            },
        },
    },
}
