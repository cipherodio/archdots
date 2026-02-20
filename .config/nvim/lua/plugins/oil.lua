return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
        {
            "-",
            function()
                require("oil").toggle_float()
            end,
            desc = "Open oil in float",
        },
    },
    opts = {
        keymaps = {
            ["<C-h>"] = false,
            ["<C-c>"] = false,
            ["q"] = "actions.close",
        },
        default_file_explorer = true,
        columns = { "icon" },
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        prompt_save_on_select_new_entry = false,
        view_options = { show_hidden = true },
        float = {
            padding = 5,
            border = "single",
        },
    },
}
