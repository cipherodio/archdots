return {
    "lewis6991/gitsigns.nvim",
    init = function()
        vim.api.nvim_create_autocmd({ "BufRead" }, {
            group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
            callback = function()
                vim.fn.system(
                    "git -C " .. '"' .. vim.fn.expand("%:p:h") .. '"' .. " rev-parse"
                )
                if vim.v.shell_error == 0 then
                    vim.api.nvim_del_augroup_by_name("GitSignsLazyLoad")
                    vim.schedule(function()
                        require("lazy").load({
                            plugins = { "gitsigns.nvim" },
                        })
                    end)
                end
            end,
        })
    end,
    ft = "gitcommit",
    keys = {
        {
            "<leade>gB",
            function()
                require("gitsigns").blame_line()
            end,
            desc = "Open git blame",
        },
        {
            "<leader>gp",
            function()
                require("gitsigns").preview_hunk_inline()
            end,
            desc = "Preview hunk",
        },
        {
            "<leader>gr",
            function()
                require("gitsigns").reset_hunk()
            end,
            mode = { "n", "v" },
            desc = "Reset hunk",
        },
        {
            "<leader>gR",
            function()
                require("gitsigns").reset_buffer()
            end,
            desc = "Reset buffer",
        },
        {
            "<leader>gs",
            function()
                require("gitsigns").stage_hunk()
            end,
            mode = { "n", "v" },
            desc = "Stage hunk",
        },
        {
            "<leader>gS",
            function()
                require("gitsigns").stage_buffer()
            end,
            desc = "Stage buffer",
        },
        {
            "<leader>gu",
            function()
                require("gitsigns").stage_hunk()
            end,
            desc = "Unstage hunk",
        },
        {
            "<leader>gd",
            function()
                require("gitsigns").diffthis()
            end,
            desc = "Open diff",
        },
        {
            "<leader>gq",
            function()
                require("gitsigns").setqflist()
            end,
            desc = "Open quickfix list with hunks",
        },
        {
            "<leader>gl",
            function()
                require("gitsigns").setloclist()
            end,
            desc = "Open location list with hunks",
        },
        {
            "<leader>gL",
            function()
                require("gitsigns").toggle_current_line_blame()
            end,
            desc = "Toggle line blame",
        },
        {
            "<leader>g]",
            function()
                ---@diagnostic disable-next-line: param-type-mismatch
                require("gitsigns").nav_hunk("next", { wrap = false })
            end,
            desc = "Next hunk",
        },
        {
            "<leader>g[",
            function()
                ---@diagnostic disable-next-line: param-type-mismatch
                require("gitsigns").nav_hunk("prev", { wrap = false })
            end,
            desc = "Previous hunk",
        },
    },
    opts = {
        attach_to_untracked = true,
        numhl = false,
        signs = {
            add = { text = "┃" },
            change = { text = "┃" },
            delete = { text = "┃" },
            topdelete = { text = "┃" },
            changedelete = { text = "┃" },
            untracked = { text = "┃" },
        },
    },
}
