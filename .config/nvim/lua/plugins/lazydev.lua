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
