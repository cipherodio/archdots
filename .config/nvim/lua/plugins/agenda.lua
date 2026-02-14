return {
    "Kamyil/markdown-agenda.nvim",
    -- Required for :MarkdownAgenda command to be available
    -- Alternatively, use: cmd = 'MarkdownAgenda' for lazy-loading on command
    lazy = false,
    opts = {
        directory = "~/hub/src/mdnotes",
        -- Options for date_format: "%Y-%m-%d" (2025-12-30),
        --"%m/%d/%Y" (12/30/2025), "%d/%m/%Y" (30/12/2025)
        date_format = "%Y-%m-%d",
        keymaps = {
            open = "<leader>aa",
        },
    },
}
