return {
    "saghen/blink.indent",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        static = {
            char = "│",
        },
        scope = {
            char = "│",
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
