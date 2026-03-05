local cb = require("utils.checkbox")
local h = require("utils.helper")
local km = require("utils.keyhelper")
local s = require("utils.scheduler")
local opt = vim.opt_local

opt.spell = true
opt.textwidth = 72
opt.linebreak = true

km.nmap("<leader>tc", h.toggle_conceal, { buffer = true, desc = "Toggle conceal" })

-- Markdown agenda scheduler
km.nmap(
    "<leader>as",
    s.insert_scheduled,
    { buffer = true, desc = "Markdown: Schedule task" }
)
km.nmap(
    "<leader>ad",
    s.insert_deadline,
    { buffer = true, desc = "Markdown: Deadline task" }
)
km.nmap(
    "<leader>ab",
    s.insert_scheduled_and_deadline,
    { buffer = true, desc = "Markdown: Scheduled + Deadline" }
)
-- Markdown checkbox toggle
km.nmap("<A-CR>", cb.toggle, { buffer = true, desc = "Markdown: Toggle Checkbox" })
-- Creates new checkbox line
km.nmap("<S-CR>", cb.new_checkbox, { buffer = true, desc = "Markdown: New checkbox" })
km.imap("<S-CR>", cb.new_checkbox, { buffer = true, desc = "Markdown: New checkbox" })
