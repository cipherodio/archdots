local k = require("utils.keyhelper")
local o = vim.opt_local
local m = require("utils.mdhelper")
local s = require("utils.scheduler")
local autocmd = vim.api.nvim_create_autocmd

local function augroup(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Options
o.spell = true
o.textwidth = 72
o.formatoptions = "tjnq"

-- Autocmds
autocmd("CursorMovedI", {
    desc = "Snap back to the left after hitting textwidth 72",
    group = augroup("snapback"),
    buffer = 0,
    callback = m.smart_snap,
})

-- Keymaps
k("n", "<leader>mc", m.toggle_conceal, {
    buffer = true,
    desc = "Markdown: toggle conceal",
})

k("n", "<leader>ms", s.insert_scheduled, {
    buffer = true,
    desc = "Markdown: schedule task",
})

k("n", "<leader>md", s.insert_deadline, {
    buffer = true,
    desc = "Markdown: deadline task",
})

k("n", "<leader>mb", s.insert_scheduled_and_deadline, {
    buffer = true,
    desc = "Markdown: scheduled + deadline",
})

k("n", "<A-CR>", m.toggle, {
    buffer = true,
    desc = "Markdown: toggle checkbox",
})

k("n", "<S-CR>", m.new_checkbox, {
    buffer = true,
    desc = "Markdown: new line checkbox",
})

k("i", "<S-CR>", m.new_checkbox, {
    buffer = true,
    desc = "Markdown: new line checkbox",
})
