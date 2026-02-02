return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        event = { "BufReadPre", "BufNewFile" },

        dependencies = {
            "andymass/vim-matchup",
        },

        config = function()
            local ts = require("nvim-treesitter")

            -- Parsers (explicit, deterministic)
            local parsers = {
                "bash",
                "commonlisp",
                "cpp",
                "css",
                "diff",
                "gitcommit",
                "gitignore",
                "git_config",
                "git_rebase",
                "html",
                "ini",
                "javascript",
                "jsdoc",
                "json",
                "lua",
                "luadoc",
                "luap",
                "markdown",
                "markdown_inline",
                "printf",
                "python",
                "query",
                "rasi",
                "ssh_config",
                "tmux",
                "toml",
                "typescript",
                "vim",
                "vimdoc",
                "xml",
                "yaml",
                "zathurarc",
            }

            -- Global message suppression (no ENTER prompts)
            vim.opt.more = false
            vim.opt.shortmess:append("F")

            if vim.fn.has("nvim-0.11") == 1 then
                vim.opt.messagesopt = {
                    "wait:1000",
                    "history:500",
                }
            end

            -- One-time bootstrap (sync, silent, deterministic)
            local marker = vim.fn.stdpath("state") .. "/treesitter_bootstrap_done"

            if vim.fn.filereadable(marker) == 0 then
                ts.install(parsers, { sync = true })
                vim.fn.writefile({ "done" }, marker)
            end

            -- Treesitter setup
            ts.setup({
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true,
                },
                matchup = {
                    enable = true,
                    include_match_words = true,
                    enable_quotes = true,
                },
            })

            -- vim-matchup globals
            vim.g.matchup_matchparen_offscreen = { method = "popup" }
            vim.g.matchup_matchparen_deferred = 1
            vim.g.matchup_matchparen_timeout = 300

            -- Safe Treesitter attach (with augroup)
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("TreesitterAttach", { clear = true }),
                callback = function()
                    pcall(vim.treesitter.start)
                    vim.wo.foldmethod = "expr"
                    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })

            -- Manual Treesitter update
            vim.keymap.set("n", "<leader>tu", function()
                vim.notify(
                    "Updating Treesitter parsers in background. Check :messages for errors.",
                    vim.log.levels.INFO
                )

                vim.cmd("TSUpdate")
            end, {
                desc = "Update Treesitter parsers",
            })
        end,
    },
}
