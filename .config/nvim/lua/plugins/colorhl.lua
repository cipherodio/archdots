return {
    "brenoprata10/nvim-highlight-colors",
    keys = {
        {
            "<leader>ac",
            function()
                require("nvim-highlight-colors").toggle()
            end,
            desc = "Color highlight toggle",
        },
    },
    -- opts = {
    --     render = "virtual",
    --     virtual_symbol = "■",
    -- },
}
