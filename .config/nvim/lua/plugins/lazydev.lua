return {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
        library = {
            "lazy.nvim",
            "nvim-dap-ui",
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
    },
}

-- Last Modified: Wed, 31 Dec 2025 12:23:39 AM
