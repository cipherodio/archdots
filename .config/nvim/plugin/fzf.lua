vim.pack.add({
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/ibhagwan/fzf-lua" },
    { src = "https://github.com/michel-garcia/fzf-lua-file-browser.nvim" },
}, { confirm = false })

local f = require("fzf-lua")
local fb = require("fzf-lua-file-browser")
local fba = require("fzf-lua-file-browser.actions")

local fh = require("utils.fzfhelper")
local k = require("utils.keyhelper")

-- FzfLua
f.setup({
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

f.register_ui_select()

-- Fzf file browser
fb.setup({
    actions = {
        ["default"] = fba.open,
        ["ctrl-p"] = fba.parent,
        ["ctrl-w"] = fba.cwd,
        ["ctrl-e"] = fba.home,
        ["ctrl-t"] = fba.toggle_hidden,
        ["ctrl-n"] = fba.create,
        ["ctrl-r"] = fba.rename,
        ["ctrl-d"] = fba.delete,
    },

    hijack_netrw = true,
    color_icons = true,
    cwd_header = false,
    dir_icon_hl = "Directory",
    file_icons = true,
})

-- Keymaps
k("n", "<leader>gf", function()
    fh.smart_git("git_files")
end, { desc = "Fzf: git files" })

k("n", "<leader>gs", function()
    fh.smart_git("git_status")
end, { desc = "Fzf: status" })

k("n", "<leader>gc", function()
    fh.smart_git("git_commits")
end, { desc = "Fzf: commits" })

k("n", "<leader>gC", function()
    fh.smart_git("git_bcommits")
end, { desc = "Fzf: buffer commits" })

k("n", "<leader>gb", function()
    fh.smart_git("git_branches")
end, { desc = "Fzf: branches" })

k("n", "<leader>fw", function()
    fh.smart_git("live_grep")
end, { desc = "Fzf: grep" })

k("n", "<leader>ff", function()
    f.files({ cwd = vim.fn.expand("%:p:h") })
end, { desc = "Fzf: cwd files" })

k("n", "<leader>fx", function()
    f.files({ cwd = "~/" })
end, { desc = "Fzf: home files" })

k("n", "<leader>fX", function()
    f.files({ cmd = "fd -tf -I -E .git . review src", cwd = "~/hub" })
end, { desc = "Fzf: hub files" })

k("n", "<leader>fn", function()
    f.files({ cwd = "~/hub/src/mdnotes/" })
end, { desc = "Fzf: notes" })

k("n", "<leader>fN", function()
    f.live_grep({ cwd = "~/hub/src/mdnotes/" })
end, { desc = "Fzf: grep notes" })

k("n", "<leader>fo", f.oldfiles, { desc = "Fzf: recent" })
k("n", "<leader>fb", f.buffers, { desc = "Fzf: buffers" })
k("n", "<leader>fk", f.keymaps, { desc = "Fzf: keymaps" })
k("n", "<leader>fh", f.helptags, { desc = "Fzf: help" })
k("n", "<leader>fC", f.commands, { desc = "Fzf: commands" })
k("n", "<leader>fc", f.command_history, { desc = "Fzf: command history" })
k("n", "<leader>fr", f.registers, { desc = "Fzf: registers" })
k("n", "<leader>fm", f.manpages, { desc = "Fzf: man pages" })
k("n", "<leader>ss", f.spell_suggest, { desc = "Fzf: spell suggest" })
k("n", "<leader>ee", fb.browse, { desc = "Fzf: browser" })
k("n", "<leader>la", f.lsp_code_actions, { desc = "Fzf: code actions" })
k("n", "<leader>ls", f.lsp_document_symbols, { desc = "Fzf: symbol LSP document" })
k("n", "<leader>ld", f.diagnostics_document, { desc = "Fzf: document diagnostics" })
k("n", "<leader>lw", f.diagnostics_workspace, { desc = "Fzf: workspace diagnostics" })
