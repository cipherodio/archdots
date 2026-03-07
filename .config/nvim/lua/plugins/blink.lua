return {
    "Saghen/blink.cmp",
    event = "InsertEnter",
    dependencies = {
        { "rafamadriz/friendly-snippets" },
        { "ribru17/blink-cmp-spell" },
    },
    version = "1.*",
    ---@module "blink.cmp"
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            ["<C-b>"] = { "scroll_documentation_up" },
            ["<C-f>"] = { "scroll_documentation_down" },
            ["<C-e>"] = { "hide" },
            ["<CR>"] = {
                "accept",
                "fallback",
            },
            ["<Tab>"] = {
                "select_next",
                "snippet_forward",
                "fallback",
            },
            ["<S-Tab>"] = {
                "select_prev",
                "snippet_backward",
                "fallback",
            },
            ["<C-Space>"] = {
                "show",
                "show_documentation",
                "hide_documentation",
            },
        },
        appearance = { nerd_font_variant = "mono" },
        signature = { enabled = true },
        sources = {
            transform_items = function(_, items)
                if vim.bo.filetype == "gitcommit" then
                    return vim.tbl_filter(function(item)
                        local label = item.label:lower()
                        return not (
                            label:match("^feat")
                            or label:match("^fix")
                            or label:match("^chore")
                            or label:match("^refactor")
                            or label:match("^style")
                            or label:match("^perf")
                            or label:match("^docs")
                        )
                    end, items)
                end
                return items
            end,
            default = {
                "lazydev",
                "lsp",
                "path",
                "snippets",
                "buffer",
                "spell",
            },
            providers = {
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    score_offset = 100,
                },
                snippets = {
                    name = "snippets",
                    module = "blink.cmp.sources.snippets",
                    score_offset = function()
                        local ft = vim.bo.filetype
                        if ft == "gitcommit" then
                            return 100
                        end
                        if ft == "markdown" then
                            return -100
                        end
                        return -20
                    end,
                },
                spell = {
                    name = "spell",
                    module = "blink-cmp-spell",
                    score_offset = function()
                        local ft = vim.bo.filetype
                        if ft == "markdown" then
                            return 50
                        end
                        if ft == "gitcommit" then
                            return 20
                        end
                        return 50
                    end,
                },
            },
            per_filetype = {
                markdown = { "spell", "lsp", "snippets", "buffer" },
                gitcommit = { "snippets", "spell", "buffer" },
            },
        },
    },
}
