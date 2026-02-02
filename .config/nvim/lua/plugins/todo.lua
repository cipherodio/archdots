return {
    "folke/todo-comments.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    event = { "BufReadPost", "BufNewFile" },
    keys = {
        {
            "<C-]>",
            function()
                require("todo-comments").jump_next()
            end,
            desc = "Jump to next todo comment",
        },
        {
            "<C-[>",
            function()
                require("todo-comments").jump_prev()
            end,
            desc = "Jump to previous todo comment",
        },
        {
            "<leader>fT",
            "<cmd>TodoFzfLua<cr>",
            desc = "TODO comments",
        },
    },
    opts = {},
}
