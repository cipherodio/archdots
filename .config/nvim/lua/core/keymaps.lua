local cur = require("utils.currency")
local h = require("utils.helper")
local km = require("utils.keyhelper")
local lsph = require("utils.lsphelper")
local r = require("utils.replacer")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic
km.nmap("q", "<nop>", { desc = "Disable q" })
km.nmap("<leader>ww", "<cmd>w<cr>", { desc = "Save file" })
km.nmap("<leader>wa", "<cmd>wa<cr>", { desc = "Save all buffer" })
km.nmap("<leader>wr", "<cmd>e!<cr>", { desc = "Revert all changes" })
km.nmap("<leader>qq", "<cmd>q!<cr>", { desc = "Force quit" })
km.nmap("<leader>qa", "<cmd>qa<cr>", { desc = "Quit all/Exit Neovim" })
km.nmap("<leader>qd", "<cmd>q<cr>", { desc = "Quit current buffer" })
km.rmap("<leader>yd", 'yi"', { desc = "Yank inside double quotes" })
km.rmap("<leader>ys", "yi'", { desc = "Yank inside single quotes" })
km.nmap("<leader>i", "<cmd>Inspect<cr>", { desc = "Inspect" })
km.emap("<esc>", h.smart_esc, { desc = "Editor: Clear Search on Escape" })
km.nmap("<leader>aD", "<cmd>%d<cr>", { desc = "DELETE ALL" })

-- Opens my agenda markdown file
km.nmap("<leader>aq", h.open_agenda, { desc = "Editor: Open Agenda" })

-- DeepSeek Balance check
km.nmap("<leader>aB", cur.check_deepseek_balance, { desc = "AI: Check Balance" })

-- LSP's
km.nmap("<leader>lo", lsph.show_root_dir, { desc = "LSP: Show Root Directory" })
km.nmap("<leader>lc", lsph.toggle_codelens, { desc = "LSP: Toggle CodeLens" })
km.nmap("<leader>li", lsph.toggle_inlay_hints, { desc = "LSP: Toggle Inlay Hints" })
km.nmap("<leader>lr", lsph.rename, { desc = "LSP: Rename Symbol" })
km.nmap("<leader>lf", lsph.toggle_autoformat, { desc = "Toggle Autoformat" })
km.nmap("[d", lsph.diag_prev, { desc = "LSP: Previous Diagnostic" })
km.nmap("]d", lsph.diag_next, { desc = "LSP: Next Diagnostic" })

-- Spelling
km.nmap("<leader>st", "zg", { desc = "Spell add Tagalog" })
km.nmap("<leader>se", "2zg", { desc = "Spell add English" })
km.nmap("<leader>sn", "]s", { desc = "Next spelling error" })
km.nmap("<leader>sp", "[s", { desc = "Previous spelling error" })
km.nmap("<leader>sw", "zw", { desc = "Mark word as wrong" })
km.nmap("<leader>su", "zuw", { desc = "Undo mark wrong" })
km.nmap("<leader>sr", "zug", { desc = "Revert add word" })
km.nmap("<leader>ss", "z=", { desc = "Spell suggestions" })

-- Buffers
km.nmap("L", "<cmd>bnext<cr>", { desc = "Next buffer" })
km.nmap("H", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
km.nmap("<leader>bv", "<cmd>vnew<cr>", { desc = "New vertical split" })
km.nmap("<leader>bh", "<cmd>new<cr>", { desc = "New Horizontal split" })
km.nmap("<leader>bV", "<cmd>vsplit<cr>", { desc = "Vertical split" })
km.nmap("<leader>bH", "<cmd>split<cr>", { desc = "Horizontal split" })
-- km.nmap("<leader>bd", "<cmd>enew | bd #<cr>", { desc = "Close buffer, keep split" })
km.nmap("<leader>bd", "<cmd>bd<cr>", { desc = "Close buffer" })

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

-- Smart navigation
km.emap("j", h.smart_j, { desc = "Editor: Move down (visual if no count)" })
km.emap("k", h.smart_k, { desc = "Editor: Move up (visual if no count)" })

-- Smart Search (Always forward with n, backward with N)
km.emap("n", h.smart_n, { desc = "Editor: Next search result" })
km.emap("N", h.smart_N, { desc = "Editor: Previous search result" })

-- Better indenting
km.vmap("<", "<gv", { desc = "Indent left and stay in visual mode" })
km.vmap(">", ">gv", { desc = "Indent right and stay in visual mode" })

-- Do not yank on x / c
km.map({ "n", "v" }, "x", '"_x', { desc = "Delete without yanking" })
km.map({ "n", "v" }, "c", '"_c', { desc = "Change without yanking" })

-- Better deletion
km.emap("dd", h.smart_dd, { desc = "Editor: Smart Delete (No yank on empty)" })

-- Word replacer
km.nmap("<leader>ar", r.replace_word_fast, { desc = "Replace all word under cursor" })
km.nmap("<leader>aR", r.replace_word_confirm, { desc = "Select with tab to replace" })
