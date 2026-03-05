return {
    "Kamyil/markdown-agenda.nvim",
    lazy = true,
    keys = {
        {
            "<leader>aa",
            "<cmd>MarkdownAgenda<cr>",
            desc = "Open agenda",
        },
    },
    ---@module "markdown-agenda"
    opts = {
        directory = "~/hub/src/mdnotes",
        recursive = true,
        date_format = "%Y-%m-%d",
        help = false,
        help_separator = false,
        border = "solid",
        title = false,
        calendar = {
            enabled = true,
            months_to_show = 3,
            position = "top",
            grid_columns = 3,
            week_start = "monday",
        },
    },
}
