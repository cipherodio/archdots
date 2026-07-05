vim.pack.add({
    { src = "https://github.com/neogitorg/neogit" },
}, { confirm = false })

require("neogit").setup({
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
})

vim.api.nvim_create_autocmd("User", {
    pattern = {
        "NeogitPushComplete",
        "NeogitPullComplete",
        "NeogitCommitComplete",
        "NeogitStageComplete",
    },
    callback = function()
        require("neogit").refresh()
    end,
})

-- Keymaps
local map = vim.keymap.set

map("n", "<leader>gg", function()
    vim.env.GIT_DIR = nil
    vim.env.GIT_WORK_TREE = nil
    require("neogit").open({ cwd = vim.fn.expand("%:p:h") })
end, { desc = "Neogit: project", silent = true })

map("n", "<leader>gd", function()
    vim.env.GIT_DIR = vim.fn.expand("~/.config/.dots")
    vim.env.GIT_WORK_TREE = vim.fn.expand("~")
    require("neogit").open({ cwd = vim.fn.expand("~") })
end, { desc = "Neogit: dotfiles", silent = true })
