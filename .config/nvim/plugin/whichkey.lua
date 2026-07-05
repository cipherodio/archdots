vim.pack.add({
    { src = "https://github.com/folke/which-key.nvim" },
}, { confirm = false })

require("which-key").setup({
    preset = "classic",
    spec = {
        {
            mode = { "n", "v" },
            { "<leader>a", group = "Action" },
            { "<leader>w", group = "Write/save" },
            { "<leader>q", group = "Quit" },
            { "<leader>y", group = "Yank" },
            { "<leader>f", group = "Find" },
            { "<leader>g", group = "Git" },
            { "<leader>b", group = "Buffer" },
            { "<leader>e", group = "Explorer" },
            { "<leader>l", group = "Lsp" },
            { "<leader>m", group = "Markdown" },
            { "<leader>p", group = "Plugin" },
            { "<leader>s", group = "Spelling" },
            { "<leader>t", group = "Task" },
            { "<leader>c", group = "Calendar" },
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
