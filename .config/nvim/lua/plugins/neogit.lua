return {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "ibhagwan/fzf-lua" },
    },
    cmd = "Neogit",
    keys = {
        {
            "<leader>gg",
            "<cmd>Neogit<cr>",
            desc = "Open neogit",
        },
    },
    opts = {
        console_timeout = 5000,
        kind = "replace",
        status = { recent_commit_count = 25 },
        auto_show_console = false,
        integrations = {
            fzf_lua = true,
            -- diffview = true,
        },
    },
}
