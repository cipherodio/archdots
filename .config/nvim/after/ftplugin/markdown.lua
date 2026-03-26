local cb = require("utils.checkbox")
local h = require("utils.helper")
local km = require("utils.keyhelper")
local s = require("utils.scheduler")
local opt = vim.opt_local

opt.spell = true
opt.textwidth = 72
opt.linebreak = true
opt.wrap = true

km.nmap(
    "<leader>mc",
    h.toggle_conceal,
    { buffer = true, desc = "Markdown: toggle conceal" }
)

-- Markdown agenda scheduler
km.nmap(
    "<leader>ms",
    s.insert_scheduled,
    { buffer = true, desc = "Markdown: schedule task" }
)
km.nmap(
    "<leader>md",
    s.insert_deadline,
    { buffer = true, desc = "Markdown: deadline task" }
)
km.nmap(
    "<leader>mb",
    s.insert_scheduled_and_deadline,
    { buffer = true, desc = "Markdown: scheduled + deadline" }
)
km.nmap("<A-CR>", cb.toggle, { buffer = true, desc = "Markdown: toggle checkbox" })
km.nmap(
    "<S-CR>",
    cb.new_checkbox,
    { buffer = true, desc = "Markdown: new line checkbox" }
)
km.imap(
    "<S-CR>",
    cb.new_checkbox,
    { buffer = true, desc = "Markdown: new line checkbox" }
)
