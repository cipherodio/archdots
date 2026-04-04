return {
    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        branch = "main",
        dependencies = {
            "andymass/vim-matchup",
            "nvim-treesitter/nvim-treesitter-context",
        },

        config = function()
            local ts = require("nvim-treesitter")

            -- Parsers
            local parsers = {
                "bash",
                "commonlisp",
                "c",
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
            -- vim.opt.more = false
            -- vim.opt.shortmess:append("F")
            --
            -- if vim.fn.has("nvim-0.11") == 1 then
            --     vim.opt.messagesopt = {
            --         "wait:1000",
            --         "history:500",
            --     }
            -- end

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
            vim.g.matchup_matchparen_offscreen = {}
            vim.g.matchup_matchline_statusline = 0
            vim.g.matchup_matchparen_statusbar = 0
            vim.g.matchup_matchparen_deferred = 1
            vim.g.matchup_matchparen_timeout = 300
            require("treesitter-context").setup({
                enable = true,
                max_lines = 1,
                min_window_height = 0,
                line_numbers = true,
                multiline_threshold = 20,
                trim_scope = "outer",
                mode = "cursor",
                separator = nil,
                zindex = 20,
            })

            -- Safe Treesitter start
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
                        or vim.bo.filetype
                    local has_parser = pcall(vim.treesitter.get_parser, 0, lang)
                    if
                        has_parser and pcall(vim.treesitter.query.get, lang, "highlights")
                    then
                        pcall(vim.treesitter.start)
                    end
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
                desc = "Treesitter: update parsers",
            })
        end,
    },
}
