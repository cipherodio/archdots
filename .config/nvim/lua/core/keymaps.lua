local cb = require("utils.currency")
local h = require("utils.helper")
local km = require("utils.keyhelper")
local lsph = require("utils.lsphelper")
local mh = require("utils.mdhelper")
local r = require("utils.replacer")
local s = require("utils.spellhelper")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic
km.nmap("q", "<nop>", { desc = "Disable q" })
km.nmap("<leader>ww", "<cmd>w<cr>", { desc = "Write: save file" })
km.nmap("<leader>wa", "<cmd>wa<cr>", { desc = "Write: save all buffer" })
km.nmap("<leader>wq", "<cmd>wq<cr>", { desc = "Write: save and quit" })
km.nmap("<leader>wr", "<cmd>e!<cr>", { desc = "Write: undo all changes" })
km.nmap("<leader>wn", h.create_and_open, { desc = "Write: new file in current dir" })
km.nmap("<leader>wt", h.create_on_disk, { desc = "Write: touch in current dir" })
km.nmap("<leader>qq", "<cmd>q!<cr>", { desc = "Quit: force" })
km.nmap("<leader>qa", "<cmd>qa<cr>", { desc = "Quit: all/exit neovim" })
km.nmap("<leader>qd", "<cmd>q<cr>", { desc = "Quit: current buffer" })
km.rmap("<leader>yd", 'yi"', { desc = "Yank: inside double quotes" })
km.rmap("<leader>ys", "yi'", { desc = "Yank: inside single quotes" })
km.nmap("<leader>i", "<cmd>Inspect<cr>", { desc = "Editor: inspect" })
km.emap("<esc>", h.smart_esc, { desc = "Editor: clear search on escape" })
km.nmap("<leader>wd", "<cmd>%d<cr>", { desc = "Write: delete all text in file" })

-- Personal
km.nmap("<leader>mf", mh.open_agenda, { desc = "Markdown: open agenda" })
km.nmap("<leader>ab", cb.check_deepseek_balance, { desc = "AI: check balance" })

-- LSP's
km.nmap("<leader>lo", lsph.show_root_dir, { desc = "LSP: show root directory" })
km.nmap("<leader>lc", lsph.toggle_codelens, { desc = "LSP: toggle codelens" })
km.nmap("<leader>li", lsph.toggle_inlay_hints, { desc = "LSP: toggle inlay hints" })
km.nmap("<leader>lr", lsph.rename, { desc = "LSP: rename symbol" })
km.nmap("<leader>lf", lsph.toggle_autoformat, { desc = "Format: toggle" })
km.nmap("[d", lsph.diag_prev, { desc = "LSP: previous diagnostic" })
km.nmap("]d", lsph.diag_next, { desc = "LSP: next diagnostic" })

-- Spelling
km.nvmap("zg", s.spell_add_lower(1), { desc = "Spell: add tagalog" })
km.nvmap("<leader>st", s.spell_add_lower(1), { desc = "Spell: add tagalog" })
km.nvmap("<leader>se", s.spell_add_lower(2), { desc = "Spell: add english" })
km.nvmap("<leader>sT", s.smart_spell(1), { desc = "Spell: undo spell tagalog" })
km.nvmap("<leader>sE", s.smart_spell(2), { desc = "Spell: undo spell english" })
km.nmap("<leader>sc", s.clean_spell_files, { desc = "Spell: clean spell file" })
km.nmap("<leader>sr", s.report_stats, { desc = "Spell: report writing stats" })
km.nmap("<leader>sn", "]s", { desc = "Spell: next spelling error" })
km.nmap("<leader>sp", "[s", { desc = "Spell: previous spelling error" })
km.nmap("<leader>sl", s.fzf_spell_all, { desc = "Fzf: list all spell errors" })

-- Buffers
km.nmap("L", "<cmd>bnext<cr>", { desc = "Buffer: next" })
km.nmap("H", "<cmd>bprevious<cr>", { desc = "Buffer: previous" })
km.nmap("<leader>bv", "<cmd>vnew<cr>", { desc = "Split: new vertical" })
km.nmap("<leader>bh", "<cmd>new<cr>", { desc = "Split: new horizontal" })
km.nmap("<leader>bV", "<cmd>vsplit<cr>", { desc = "Split: vertical" })
km.nmap("<leader>bH", "<cmd>split<cr>", { desc = "Split: horizontal" })
km.nmap("<leader>bd", "<cmd>bd<cr>", { desc = "Split: close buffer" })

-- Window navigation
km.nmap("<C-h>", "<C-w>h", { desc = "move to left window" })
km.nmap("<C-j>", "<C-w>j", { desc = "move to lower window" })
km.nmap("<C-k>", "<C-w>k", { desc = "move to upper window" })
km.nmap("<C-l>", "<C-w>l", { desc = "move to right window" })

-- Resize windows
km.nmap("<C-Up>", "<cmd>resize +2<cr>", { desc = "increase window height" })
km.nmap("<C-Down>", "<cmd>resize -2<cr>", { desc = "decrease window height" })
km.nmap("<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "decrease window width" })
km.nmap("<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "increase window width" })

-- Move lines / selections
km.nmap("<A-j>", "<cmd>m .+1<cr>==", { desc = "move line down" })
km.nmap("<A-k>", "<cmd>m .-2<cr>==", { desc = "move line up" })
km.imap("<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "move line down" })
km.imap("<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "move line up" })
km.vmap("<A-j>", ":m '>+1<cr>gv=gv", { desc = "move selection down" })
km.vmap("<A-k>", ":m '<-2<cr>gv=gv", { desc = "move selection up" })

-- Smart navigation
km.emap("j", h.smart_j, { desc = "move down (visual if no count)" })
km.emap("k", h.smart_k, { desc = "move up (visual if no count)" })

-- Smart Search (Always forward with n, backward with N)
km.emap("n", h.smart_n, { desc = "next search result" })
km.emap("N", h.smart_N, { desc = "previous search result" })

-- Better indenting
km.vmap("<", "<gv", { desc = "indent left and stay in visual mode" })
km.vmap(">", ">gv", { desc = "indent right and stay in visual mode" })

-- Do not yank on x / c
km.map({ "n", "v" }, "x", '"_x', { desc = "delete without yanking" })
km.map({ "n", "v" }, "c", '"_c', { desc = "change without yanking" })

-- Better deletion
km.emap("dd", h.smart_dd, { desc = "no yank on empty" })

-- Word replacer
km.nmap("<leader>ar", r.replace_word_fast, { desc = "Replacer: all word" })
km.nmap("<leader>aR", r.replace_word_confirm, { desc = "Replacer: tab to select word" })
