vim.pack.add({
    { src = "https://github.com/cipherodio/taskmd.nvim" },
    { src = "https://github.com/cipherodio/notesmd.nvim" },
    { src = "https://github.com/folke/todo-comments.nvim" },
}, { confirm = false })

require("taskmd").setup({
    root_dir = "~/hub/src/mdnotes",
    scan_dir = "events",
    task_file = "agenda.md",
    sync_on_open = {
        enable = true,
        autowrite = true,
    },
    write_on_command = true,
    short_uuid = true,
    highlight = {
        file_output = {
            enable = true,
        },
        calendar = {
            border = "single",
        },
    },
    keymaps = {
        add = "<leader>ta",
        sync = "<leader>ts",
        delete = "<leader>tx",
        done = "<leader>td",
        fetch = "<leader>tf",
        calendar = "<leader>c",
    },
})

require("notesmd").setup({
    notes_dir = vim.fn.expand("~/hub/src/mdnotes"),
    types = {
        journal = {
            dir = "journal",
            frontmatter = {
                fields = {
                    title = "Journal",
                    author = "Jeremy",
                    created = true,
                },
                sort_order = {
                    "title",
                    "author",
                    "created",
                },
            },
        },
        prose = {
            dir = "prose",
            frontmatter = {
                fields = {
                    title = "input",
                    author = "input",
                    created = true,
                    completed = "",
                    uploaded = "",
                    description = "input",
                },
                sort_order = {
                    "title",
                    "author",
                    "created",
                    "completed",
                    "uploaded",
                    "description",
                },
            },
        },
        vault = {
            dir = "vault",
            frontmatter = {
                fields = {
                    title = "input",
                    author = "input",
                    created = true,
                    description = "input",
                },
                sort_order = {
                    "title",
                    "author",
                    "created",
                    "description",
                },
            },
        },
        inbox = {
            dir = "inbox",
            frontmatter = {
                fields = {
                    title = "input",
                    author = "Jeremy",
                    created = true,
                    description = "input",
                },
                sort_order = {
                    "title",
                    "author",
                    "created",
                    "description",
                },
            },
        },
    },
    keymaps = {
        journal = "<leader>mj",
        prose = "<leader>mp",
        vault = "<leader>mv",
        inbox = "<leader>mi",
        completestamp = "<leader>mc",
        uploadstamp = "<leader>mu",
    },
})

require("todo-comments").setup({
    signs = false,
})

-- -- Keymaps
local map = vim.keymap.set

-- -- Todo comments
map("n", "<C-]>", function()
    require("todo-comments").jump_next()
end, {
    desc = "Jump to next todo comment",
    silent = true,
})

map("n", "<C-[>", function()
    require("todo-comments").jump_prev()
end, {
    desc = "Jump to previous todo comment",
    silent = true,
})

map("n", "<leader>fT", "<cmd>TodoFzfLua<cr>", {
    desc = "Todo: comments",
    silent = true,
})

map("n", "<leader>tq", "<cmd>TodoQuickFix<cr><cmd>copen<cr>", {
    desc = "Todo: quickfix list",
    silent = true,
})
