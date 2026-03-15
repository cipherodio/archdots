return {
    "brenoprata10/nvim-highlight-colors",
    ---@module "nvim-highlight-colors"
    keys = {
        {
            "<leader>ah",
            function()
                require("nvim-highlight-colors").toggle()
            end,
            desc = "Toggle: color highlight",
        },
    },
    -- opts = {
    --     render = "virtual",
    --     virtual_symbol = "󰝤", --"■",
    --     virtual_symbol_position = "eol",
    -- },
}
