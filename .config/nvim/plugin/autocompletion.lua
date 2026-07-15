vim.pack.add({
    "https://github.com/saghen/blink.lib",
    { src = "https://github.com/saghen/blink.pairs", version = vim.version.range("*") },
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    { src = "https://github.com/ribru17/blink-cmp-spell" },
    { src = "https://github.com/saghen/blink.indent" },
}, { confirm = false })

---@diagnostic disable-next-line: undefined-field
require("blink.pairs").download():pwait(60000)

require("blink.pairs").setup({
    highlights = {
        enabled = true,
        matchparen = {
            enabled = true,
            include_surrounding = true,
        },
    },
})

require("blink.cmp").setup({
    keymap = {
        ["<C-b>"] = { "scroll_documentation_up" },
        ["<C-f>"] = { "scroll_documentation_down" },
        ["<C-e>"] = { "hide" },
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
    },
    cmdline = {
        completion = {
            menu = { auto_show = true },
        },
    },
    completion = {
        ghost_text = { enabled = false },
        list = {
            selection = {
                preselect = false,
                auto_insert = false,
            },
        },
    },
    appearance = { nerd_font_variant = "mono" },
    signature = {
        enabled = true,
        trigger = { enabled = false },
    },
    sources = {
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
})

require("blink-indent").setup({
    static = {
        enabled = true,
        char = "│",
    },
    scope = {
        enabled = false,
        char = "│",
    },
})
