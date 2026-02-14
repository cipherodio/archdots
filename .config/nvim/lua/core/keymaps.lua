local km = require("utils.keymaps")

local checkbox = require("utils.checkbox")
local replace = require("utils.replace")
local scheduled = require("utils.scheduled")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Fast replace (no confirm)
km.nmap("<leader>ar", replace.replace_word_fast, {
    desc = "Replace word under cursor (entire file)",
})

-- Confirm replace
km.nmap("<leader>aR", replace.replace_word_confirm, {
    desc = "Replace word (confirm each)",
})

-- Basic
km.nmap("<leader>an", "<cmd>enew<cr>", { desc = "New file" })
km.nmap("<leader>w", "<cmd>w<cr>", { desc = "Save file" })
km.nmap("<leader>q", "<cmd>q!<cr>", { desc = "Force quit" })

-- Splits
km.nmap("<leader><tab>h", "<cmd>new<cr>", { desc = "Horizontal split" })
km.nmap("<leader><tab>v", "<cmd>vnew<cr>", { desc = "Vertical split" })

-- Buffers
km.nmap("<Tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
km.nmap("<S-Tab>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
km.nmap("<leader><tab>d", "<cmd>bd<cr>", { desc = "Close buffer" })

-- Close buffer, keep split layout
km.nmap("<leader><tab>i", function()
    local cur_buf = vim.api.nvim_get_current_buf()
    local cur_win = vim.api.nvim_get_current_win()

    vim.cmd.enew()
    local empty_buf = vim.api.nvim_get_current_buf()

    vim.api.nvim_win_set_buf(cur_win, empty_buf)
    vim.api.nvim_buf_delete(cur_buf, { force = true })
end, { desc = "Close file with split layout intact" })

-- Window navigation
km.nmap("<C-h>", "<C-w>h", { desc = "Move to left window" })
km.nmap("<C-j>", "<C-w>j", { desc = "Move to lower window" })
km.nmap("<C-k>", "<C-w>k", { desc = "Move to upper window" })
km.nmap("<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resize windows
km.nmap("<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
km.nmap("<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
km.nmap("<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
km.nmap("<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move lines / selections
km.nmap("<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
km.nmap("<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })

km.imap("<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
km.imap("<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })

km.vmap("<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
km.vmap("<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Better indenting
km.vmap("<", "<gv", { desc = "Indent left and stay in visual mode" })
km.vmap(">", ">gv", { desc = "Indent right and stay in visual mode" })

-- Do not yank on x / c
km.nmap("x", '"_x', { desc = "Delete without yanking" })
km.vmap("x", '"_x', { desc = "Delete without yanking" })
km.nmap("c", '"_c', { desc = "Change without yanking" })
km.vmap("c", '"_c', { desc = "Change without yanking" })

-- Smart dd
km.nmap("dd", function()
    if vim.fn.getline(".") == "" then
        return '"_dd'
    end
    return "dd"
end, {
    expr = true,
    desc = "Delete line (don’t yank empty lines)",
})

-- Smart j/k
km.nmap("j", "v:count == 0 ? 'gj' : 'j'", {
    expr = true,
    desc = "Move down (visual line if no count)",
})

km.nmap("k", "v:count == 0 ? 'gk' : 'k'", {
    expr = true,
    desc = "Move up (visual line if no count)",
})

-- Search navigation
km.nmap("n", "'Nn'[v:searchforward] .. 'zv'", {
    expr = true,
    desc = "Next search result",
})

km.nmap("N", "'nN'[v:searchforward] .. 'zv'", {
    expr = true,
    desc = "Previous search result",
})

-- Escape clears hlsearch
km.nmap("<esc>", function()
    if vim.v.hlsearch == 1 then
        vim.cmd("noh")
    end
    return "<esc>"
end, { expr = true, desc = "Escape and clear hlsearch" })

-- Inlay hints
km.nmap("<leader>li", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ 0 }), { 0 })
end, { desc = "Toggle inlay hints" })

-- Diagnostics
km.nmap("[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })

km.nmap("]d", function()
    vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })

-- Opens my agenda markdown file
km.nmap("<leader>aq", function()
    vim.cmd.edit(vim.fn.expand("~/.local/src/mdnotes/agenda.md"))
end, {
    desc = "Open agenda.md",
})

-- Markdown tools
km.nmap("<C-Space>", checkbox.toggle, {
    desc = "Toggle checkbox [ ] → [x] → [-]",
})

-- Insert @scheduled(YYYY-MM-DD)
km.nmap("<leader>as", scheduled.insert_scheduled_checkbox, {
    desc = "Insert @scheduled(YYYY-MM-DD)",
})

-- Insert @deadline(YYYY-MM-DD)
km.nmap("<leader>ad", scheduled.insert_deadline_checkbox, {
    desc = "Insert @deadline(YYYY-MM-DD)",
})

-- Insert both @scheduled(YYYY-MM-DD) @deadline(YYYY-MM-DD)
km.nmap("<leader>aD", scheduled.insert_scheduled_and_deadline_checkbox, {
    desc = "Insert @scheduled + @deadline checkbox",
})
