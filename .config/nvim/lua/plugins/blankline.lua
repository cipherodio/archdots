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

-- Last Modified: Thu, 08 Jan 2026 11:56:55 AM
