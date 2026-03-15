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
            function()
                vim.env.GIT_DIR = nil
                vim.env.GIT_WORK_TREE = nil
                require("neogit").open({ cwd = vim.fn.expand("%:p:h") })
            end,
            desc = "Neogit: project",
        },
        {
            "<leader>gd",
            function()
                vim.env.GIT_DIR = vim.fn.expand("~/.config/.dots")
                vim.env.GIT_WORK_TREE = vim.fn.expand("~")
                require("neogit").open({ cwd = vim.fn.expand("~") })
                -- Optional: Resets after opening so other plugins
                -- don't get confused
                -- vim.defer_fn(function()
                --     vim.env.GIT_DIR = nil
                --     vim.env.GIT_WORK_TREE = nil
                -- end, 1000)
            end,
            desc = "Neogit: dotfiles",
        },
    },
    config = function(_, opts)
        local neogit = require("neogit")
        neogit.setup(opts)

        -- NOTE: Force a manual refresh after any Git process finishes
        -- This mimics what happens when you switch Qtile workspaces
        vim.api.nvim_create_autocmd("User", {
            pattern = {
                "NeogitPushComplete",
                "NeogitPullComplete",
                "NeogitCommitComplete",
                "NeogitStageComplete",
            },
            callback = function()
                neogit.refresh()
            end,
        })
    end,
    ---@module "neogit"
    opts = {
        console_timeout = 60000,
        auto_show_console = false,
        auto_refresh = true,
        refresh_manually = false,
        kind = "floating",
        floating = {
            border = "rounded",
            width = 0.9,
            height = 0.8,
        },
        status = {
            recent_commit_count = 25,
            update_on_focus = true,
        },
        integrations = { fzf_lua = true },
        mappings = {
            popup = {
                ["p"] = "PushPopup",
                ["P"] = "PullPopup",
            },
        },
    },
}
