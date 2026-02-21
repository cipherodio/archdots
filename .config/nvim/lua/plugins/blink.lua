return {
    "Saghen/blink.cmp",
    event = "InsertEnter",
    dependencies = {
        { "rafamadriz/friendly-snippets" },
        -- { "ribru17/blink-cmp-spell" },
    },
    version = "1.*",
    opts = {
        keymap = {
            ["<C-b>"] = { "scroll_documentation_up" },
            ["<C-f>"] = { "scroll_documentation_down" },
            ["<C-e>"] = { "hide" },
            ["<CR>"] = { "accept", "fallback" },
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
        appearance = {
            nerd_font_variant = "mono",
        },
        -- completion = {
        --     ghost_text = { enabled = true },
        -- },
        signature = { enabled = true },
        sources = {
            default = {
                "lazydev",
                "lsp",
                "path",
                "snippets",
                "buffer",
                -- "spell",
            },
            providers = {
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    score_offset = 100,
                },
                -- spell = {
                --     name = "Spell",
                --     module = "blink-cmp-spell",
                -- },
            },
            per_filetype = {
                markdown = { "lsp", "snippets", "buffer" },
            },
        },
    },
}
