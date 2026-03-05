return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },

    keys = {
        {
            "<leader>ee",
            function()
                require("oil").toggle_float()
            end,
            desc = "Open oil in float in cwd",
        },
        {
            "<leader>eh",
            function()
                require("oil").toggle_float("~")
            end,
            desc = "Home directory",
        },
        {
            "<leader>en",
            function()
                require("oil").toggle_float("~/hub/src/mdnotes")
            end,
            desc = "Notes directory",
        },
        {
            "<leader>ep",
            function()
                require("oil").toggle_float("~/hub/src")
            end,
            desc = "Project directory",
        },
        {
            "<leader>er",
            function()
                require("oil").toggle_float("~/hub/review")
            end,
            desc = "Review directory",
        },
    },

    opts = {
        default_file_explorer = false,
        skip_confirm_for_simple_edits = true,
        prompt_save_on_select_new_entry = false,
        delete_to_trash = true,
        columns = {
            "icon",
            "permissions",
            "size",
            "mtime",
        },
        view_options = {
            show_hidden = true,
            natural_order = true,
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

    config = function(_, opts)
        require("oil").setup(opts)

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "oil",
            callback = function()
                vim.opt_local.winfixwidth = true
                vim.opt_local.number = false
                vim.opt_local.relativenumber = false
                vim.opt_local.signcolumn = "no"
            end,
        })
    end,
}
