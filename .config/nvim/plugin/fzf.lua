vim.pack.add({
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/ibhagwan/fzf-lua" },
    { src = "https://github.com/michel-garcia/fzf-lua-file-browser.nvim" },
}, { confirm = false })

-- FzfLua
require("fzf-lua").setup({
    defaults = {
        file_icons = true,
        git_icons = true,
    },

    winopts = {
        border = "single",
        row = 0.55,
        col = 0.50,
        backdrop = 100,
        ---@diagnostic disable-next-line: missing-fields
        preview = {
            hidden = false,
            scrollbar = false,
            title_pos = "left",
            layout = "vertical",
            vertical = "down:70%",
        },
    },
})
require("fzf-lua").register_ui_select()

-- Fzf file browser
require("fzf-lua-file-browser").setup({
    actions = {
        ["default"] = require("fzf-lua-file-browser.actions").open,
        ["ctrl-p"] = require("fzf-lua-file-browser.actions").parent,
        ["ctrl-w"] = require("fzf-lua-file-browser.actions").cwd,
        ["ctrl-e"] = require("fzf-lua-file-browser.actions").home,
        ["ctrl-t"] = require("fzf-lua-file-browser.actions").toggle_hidden,
        ["ctrl-n"] = require("fzf-lua-file-browser.actions").create,
        ["ctrl-r"] = require("fzf-lua-file-browser.actions").rename,
        ["ctrl-d"] = require("fzf-lua-file-browser.actions").delete,
    },

    hijack_netrw = true,
    color_icons = true,
    cwd_header = false,
    dir_icon_hl = "Directory",
    file_icons = true,
})

-- Keymaps
local map = vim.keymap.set

map("n", "<leader>gf", function()
    require("fn.fzf").smart_git("git_files")
end, { desc = "Fzf: git files", silent = true })

map("n", "<leader>gS", function()
    require("fn.fzf").smart_git("git_status")
end, { desc = "Fzf: status", silent = true })

map("n", "<leader>gc", function()
    require("fn.fzf").smart_git("git_commits")
end, { desc = "Fzf: commits", silent = true })

map("n", "<leader>gC", function()
    require("fn.fzf").smart_git("git_bcommits")
end, { desc = "Fzf: buffer commits", silent = true })

map("n", "<leader>gb", function()
    require("fn.fzf").smart_git("git_branches")
end, { desc = "Fzf: branches", silent = true })

map("n", "<leader>fw", function()
    require("fn.fzf").smart_git("live_grep")
end, { desc = "Fzf: grep", silent = true })

map("n", "<leader>ff", function()
    require("fzf-lua").files({ cwd = vim.fn.expand("%:p:h") })
end, { desc = "Fzf: cwd files", silent = true })

map("n", "<leader>fx", function()
    require("fzf-lua").files({ cwd = "~/" })
end, { desc = "Fzf: home files", silent = true })

map("n", "<leader>fX", function()
    require("fzf-lua").files({ cmd = "fd -tf -I -E .git . review src", cwd = "~/hub" })
end, { desc = "Fzf: hub files", silent = true })

map("n", "<leader>fn", function()
    require("fzf-lua").files({ cwd = "~/hub/src/mdnotes/" })
end, { desc = "Fzf: notes", silent = true })

map("n", "<leader>fN", function()
    require("fzf-lua").live_grep({ cwd = "~/hub/src/mdnotes/" })
end, { desc = "Fzf: grep notes", silent = true })

map("n", "<leader>fo", require("fzf-lua").oldfiles, {
    desc = "Fzf: recent",
    silent = true,
})

map("n", "<leader>fb", require("fzf-lua").buffers, {
    desc = "Fzf: buffers",
    silent = true,
})

map("n", "<leader>fk", require("fzf-lua").keymaps, {
    desc = "Fzf: keymaps",
    silent = true,
})

map("n", "<leader>fh", require("fzf-lua").helptags, { desc = "Fzf: help", silent = true })

map("n", "<leader>fC", require("fzf-lua").commands, {
    desc = "Fzf: commands",
    silent = true,
})

map("n", "<leader>fc", require("fzf-lua").command_history, {
    desc = "Fzf: command history",
    silent = true,
})

map("n", "<leader>fr", require("fzf-lua").registers, {
    desc = "Fzf: registers",
    silent = true,
})

map("n", "<leader>fm", require("fzf-lua").manpages, {
    desc = "Fzf: man pages",
    silent = true,
})

map("n", "<leader>ss", require("fzf-lua").spell_suggest, {
    desc = "Fzf: spell suggest",
    silent = true,
})

map("n", "<leader>ee", require("fzf-lua-file-browser").browse, {
    desc = "Fzf: browser",
    silent = true,
})

map("n", "<leader>la", require("fzf-lua").lsp_code_actions, {
    desc = "Fzf: code actions",
    silent = true,
})

map("n", "<leader>ls", require("fzf-lua").lsp_document_symbols, {
    desc = "Fzf: symbol LSP document",
    silent = true,
})

map("n", "<leader>ld", require("fzf-lua").diagnostics_document, {
    desc = "Fzf: document diagnostics",
    silent = true,
})

map("n", "<leader>lw", require("fzf-lua").diagnostics_workspace, {
    desc = "Fzf: workspace diagnostics",
    silent = true,
})
