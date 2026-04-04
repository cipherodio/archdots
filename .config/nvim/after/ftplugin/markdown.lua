local km = require("utils.keyhelper")
local mh = require("utils.mdhelper")
local s = require("utils.scheduler")
local opt = vim.opt_local

local autocmd = vim.api.nvim_create_autocmd
local function augroup(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end

opt.spell = true
opt.textwidth = 72
opt.formatoptions = "tjnq"

autocmd("CursorMovedI", {
    desc = "Snap back to the left after hitting textwidth 72",
    group = augroup("snapback"),
    buffer = 0,
    callback = function()
        mh.smart_snap()
    end,
})

km.nmap(
    "<leader>mc",
    mh.toggle_conceal,
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
km.nmap("<A-CR>", mh.toggle, { buffer = true, desc = "Markdown: toggle checkbox" })
km.nmap(
    "<S-CR>",
    mh.new_checkbox,
    { buffer = true, desc = "Markdown: new line checkbox" }
)
km.imap(
    "<S-CR>",
    mh.new_checkbox,
    { buffer = true, desc = "Markdown: new line checkbox" }
)
