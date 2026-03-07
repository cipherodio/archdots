return {
    "stevearc/oil.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
        {
            "<leader>ee",
            function()
                require("oil").toggle_float()
            end,
            desc = "Oil: open float in cwd",
        },
        {
            "<leader>eh",
            function()
                require("oil").toggle_float("~")
            end,
            desc = "Oil: home directory",
        },
        {
            "<leader>en",
            function()
                require("oil").toggle_float("~/hub/src/mdnotes")
            end,
            desc = "Oil: notes directory",
        },
        {
            "<leader>ep",
            function()
                require("oil").toggle_float("~/hub/src")
            end,
            desc = "Oil: project directory",
        },
        {
            "<leader>er",
            function()
                require("oil").toggle_float("~/hub/review")
            end,
            desc = "Oil: review directory",
        },
    },
    ---@module "oil"
    ---@type oil.SetupOpts
    opts = {
        default_file_explorer = true,
        skip_confirm_for_simple_edits = true,
        prompt_save_on_select_new_entry = false,
        delete_to_trash = true,
        columns = {
            "icon",
            "permissions",
            "size",
            "mtime",
        },
        win_options = {
            wrap = false,
            number = false,
            relativenumber = false,
        },
        view_options = {
            show_hidden = true,
            natural_order = true,
            show_header = false,
            is_always_hidden = function(name, _)
                return name == ".." or name == ".git"
            end,
        },
        float = {
            enabled = true,
            padding = 2,
            max_width = 70,
            max_height = 15,
            border = "solid",
        },
        use_default_keymaps = false,
        keymaps = {
            -- ["<C-h>"] = false,
            -- ["<C-l>"] = false,
            ["<C-c>"] = false,
            ["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
            ["_"] = { "actions.open_cwd", mode = "n" },
            ["R"] = "actions.refresh",
            -- ["<A-h>"] = "actions.parent",
            -- ["<A-l>"] = "actions.select",
            ["<C-h>"] = "actions.parent",
            ["<C-l>"] = "actions.select",
            ["q"] = "actions.close",
        },
    },
}
