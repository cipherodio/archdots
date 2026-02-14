return {
    "Saghen/blink.cmp",
    event = "InsertEnter",
    dependencies = "rafamadriz/friendly-snippets",
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
        signature = { enabled = true },
    },
}
