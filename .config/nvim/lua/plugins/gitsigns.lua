return {
    "lewis6991/gitsigns.nvim",
    lazy = true,
    init = function()
        vim.api.nvim_create_autocmd({ "BufRead" }, {
            desc = "Workaround for Git bare and normal repository",
            group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
            callback = function()
                local path = vim.api.nvim_buf_get_name(0)
                if path == "" or vim.bo.buftype ~= "" then
                    return
                end

                local bare_git_dir = vim.env.HOME .. "/.config/.dots"
                local home_dir = vim.env.HOME

                -- Check for standard local git repo
                local is_git = vim.system({ "git", "rev-parse", "--is-inside-work-tree" })
                    :wait().code == 0

                -- Check bare repo
                local is_dotfile = false
                if not is_git then
                    local obj = vim.system({
                        "git",
                        "--git-dir=" .. bare_git_dir,
                        "--work-tree=" .. home_dir,
                        "ls-files",
                        "--error-unmatch",
                        path,
                    }):wait()
                    is_dotfile = obj.code == 0
                end

                -- Load Gitsigns if it's a repo or a tracked dotfile
                if is_git or is_dotfile then
                    require("lazy").load({ plugins = { "gitsigns.nvim" } })
                    vim.api.nvim_del_augroup_by_name("GitSignsLazyLoad")
                end
            end,
        })
    end,
    keys = {
        {
            "]c",
            function()
                if vim.wo.diff then
                    return "]c"
                end
                vim.schedule(function()
                    ---@diagnostic disable-next-line: missing-fields
                    require("gitsigns").nav_hunk("next", { wrap = false })
                end)
                return "<Ignore>"
            end,
            expr = true,
            desc = "GS: next hunk",
        },
        {
            "[c",
            function()
                if vim.wo.diff then
                    return "[c"
                end
                vim.schedule(function()
                    ---@diagnostic disable-next-line: missing-fields
                    require("gitsigns").nav_hunk("prev", { wrap = false })
                end)
                return "<Ignore>"
            end,
            expr = true,
            desc = "GS: previous hunk",
        },
        {
            "<leader>gp",
            function()
                require("gitsigns").preview_hunk_inline()
            end,
            desc = "GS: preview hunk",
        },
        {
            "<leader>gr",
            function()
                local gs = require("gitsigns")
                local mode = vim.api.nvim_get_mode().mode
                if mode == "v" or mode == "V" then
                    gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                else
                    gs.reset_hunk()
                end
            end,
            mode = { "n", "v" },
            desc = "GS: reset hunk",
        },
        {
            "<leader>gl",
            function()
                require("gitsigns").toggle_current_line_blame()
            end,
            desc = "GS: toggle line blame",
        },
        {
            "<leader>gS",
            function()
                local gs = require("gitsigns")
                local mode = vim.api.nvim_get_mode().mode
                if mode == "v" or mode == "V" then
                    gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                else
                    gs.stage_hunk()
                end
            end,
            mode = { "n", "v" },
            desc = "GS: stage hunk",
        },
    },
    opts = {
        attach_to_untracked = true,
        numhl = false,
        current_line_blame = false,
        signs = {
            add = { text = "┃" },
            change = { text = "┃" },
            delete = { text = "┃" },
            topdelete = { text = "┃" },
            changedelete = { text = "┃" },
            untracked = { text = "┃" },
        },
        -- NOTE: This tells Gitsigns the path of my Bare repo
        worktrees = {
            {
                toplevel = vim.env.HOME,
                gitdir = vim.env.HOME .. "/.config/.dots",
            },
        },
    },
}
