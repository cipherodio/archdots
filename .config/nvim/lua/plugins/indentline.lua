return {
    "saghen/blink.indent",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        static = {
            char = "│",
        },
        scope = {
            enabled = false,
            char = "│",
            underline = { enabled = false },
        },
        blocked = {
            filetypes = {
                "checkhealth",
                "lazy",
                "dashboard",
                "markdown-agenda",
                "help",
                "man",
                "gitcommit",
            },
        },
    },
}
