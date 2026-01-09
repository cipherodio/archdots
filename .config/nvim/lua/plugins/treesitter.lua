return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        event = { "BufReadPre", "BufNewFile" },
        build = ":TSUpdate",

        dependencies = {
            "andymass/vim-matchup",
        },

        config = function()
            local ts = require("nvim-treesitter")

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

            -- Prevents ENTER prompt
            local function silent_install(list, opts)
                local old_more = vim.o.more
                local old_shortmess = vim.o.shortmess

                vim.o.more = false
                vim.o.shortmess = old_shortmess .. "F"

                ts.install(list, opts)

                vim.o.more = old_more
                vim.o.shortmess = old_shortmess
            end

            -- one-time bootstrap marker
            local marker = vim.fn.stdpath("state") .. "/treesitter_bootstrap_done"

            if vim.fn.filereadable(marker) == 0 then
                -- FIRST RUN: blocking + silent (bootstrap)
                silent_install(parsers, { sync = true })
                vim.fn.writefile({ "done" }, marker)
            else
                -- NORMAL RUNS: async (no spam anyway)
                ts.install(parsers, { sync = false })
            end

            -- Treesitter setup (main API)
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

            -- attach Treesitter per buffer
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "*",
                callback = function()
                    pcall(vim.treesitter.start)
                    vim.wo.foldmethod = "expr"
                    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    },
}

-- Last Modified: Sat, 10 Jan 2026 12:38:33 AM
