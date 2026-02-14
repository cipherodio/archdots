return {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
        "ibhagwan/fzf-lua",
    },
    cmd = "Neogit",
    keys = {
        {
            "<leader>gg",
            function()
                return require("neogit").open()
            end,
            desc = "Open neogit",
        },
    },
    opts = {
        console_timeout = 10000,
        kind = "replace",
        status = { recent_commit_count = 25 },
        integrations = {
            fzf_lua = true,
            diffview = true,
        },
        auto_show_console = false,
    },
}
