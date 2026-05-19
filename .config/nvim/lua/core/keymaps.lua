local b = require("utils.balance")
local h = require("utils.helper")
local k = require("utils.keyhelper")
local l = require("utils.lsphelper")
local m = require("utils.mdhelper")
local r = require("utils.replacer")
local s = require("utils.spellhelper")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- General
k("n", "q", "<nop>", { desc = "Disable q" })
k.e("n", "<esc>", h.smart_esc, { desc = "Editor: clear search on escape" })
k("n", "<leader>i", "<cmd>Inspect<cr>", { desc = "Editor: inspect" })
k("n", "<leader>pu", h.plugin_stats, { desc = "Plugins: check status" })
k("n", "<leader>mf", m.open_agenda, { desc = "Markdown: open agenda" })
k("n", "<leader>ab", b.check_deepseek_balance, { desc = "AI: check balance" })

k("n", "<leader>ww", "<cmd>w<cr>", { desc = "Write: save" })
k("n", "<leader>wa", "<cmd>wa<cr>", { desc = "Write: save all buffer" })
k("n", "<leader>wq", "<cmd>wq<cr>", { desc = "Write: save and quit" })
k("n", "<leader>wr", "<cmd>e!<cr>", { desc = "Write: undo all changes" })
k("n", "<leader>wd", "<cmd>%d<cr>", { desc = "Write: delete all text" })
k("n", "<leader>wn", h.create_and_open, { desc = "Write: new file in cwd" })
k("n", "<leader>wt", h.create_on_disk, { desc = "Write: touch in cwd" })

k("n", "<leader>qq", "<cmd>q!<cr>", { desc = "Quit: force" })
k("n", "<leader>qa", "<cmd>qa<cr>", { desc = "Quit: all" })
k("n", "<leader>qd", "<cmd>q<cr>", { desc = "Quit: current buffer" })

k.r("n", "<leader>yd", 'yi"', { desc = "Yank: inside double quotes" })
k.r("n", "<leader>ys", "yi'", { desc = "Yank: inside single quotes" })

-- LSP
k("n", "<leader>lo", l.show_root_dir, { desc = "LSP: show root directory" })
k("n", "<leader>lc", l.toggle_codelens, { desc = "LSP: toggle codelens" })
k("n", "<leader>li", l.toggle_inlay_hints, { desc = "LSP: toggle inlay hints" })
k("n", "<leader>lr", l.rename, { desc = "LSP: rename symbol" })
k("n", "<leader>lf", l.toggle_autoformat, { desc = "Format: toggle" })
k("n", "[d", l.diag_prev, { desc = "LSP: previous diagnostic" })
k("n", "]d", l.diag_next, { desc = "LSP: next diagnostic" })

-- Spelling
k({ "n", "v" }, "zg", s.spell_add_lower(1), { desc = "Spell: add tagalog" })
k({ "n", "v" }, "<leader>st", s.spell_add_lower(1), { desc = "Spell: add tagalog" })
k({ "n", "v" }, "<leader>se", s.spell_add_lower(2), { desc = "Spell: add english" })
k({ "n", "v" }, "<leader>sT", s.smart_spell(1), { desc = "Spell: undo spell tagalog" })
k({ "n", "v" }, "<leader>sE", s.smart_spell(2), { desc = "Spell: undo spell english" })
k("n", "<leader>sc", s.clean_spell_files, { desc = "Spell: clean spell file" })
k("n", "<leader>sr", s.report_stats, { desc = "Spell: report writing stats" })
k("n", "<leader>sn", "]s", { desc = "Spell: next spelling error" })
k("n", "<leader>sp", "[s", { desc = "Spell: previous spelling error" })
k("n", "<leader>sl", s.fzf_spell_all, { desc = "Fzf: list all spell errors" })

-- Buffers
k("n", "L", "<cmd>bnext<cr>", { desc = "Buffer: next" })
k("n", "H", "<cmd>bprevious<cr>", { desc = "Buffer: previous" })
k("n", "<leader>bv", "<cmd>vnew<cr>", { desc = "Split: new vertical" })
k("n", "<leader>bh", "<cmd>new<cr>", { desc = "Split: new horizontal" })
k("n", "<leader>bV", "<cmd>vsplit<cr>", { desc = "Split: vertical" })
k("n", "<leader>bH", "<cmd>split<cr>", { desc = "Split: horizontal" })
k("n", "<leader>bd", "<cmd>bd<cr>", { desc = "Split: close buffer" })

-- Window navigation
k("n", "<C-h>", "<C-w>h", { desc = "move to left window" })
k("n", "<C-j>", "<C-w>j", { desc = "move to lower window" })
k("n", "<C-k>", "<C-w>k", { desc = "move to upper window" })
k("n", "<C-l>", "<C-w>l", { desc = "move to right window" })

-- Move lines/selections
k("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "move line down" })
k("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "move line up" })
k("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "move line down" })
k("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "move line up" })
k("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "move selection down" })
k("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "move selection up" })

-- Smart navigation
k.e("n", "j", h.smart_j, { desc = "move down (visual if no count)" })
k.e("n", "k", h.smart_k, { desc = "move up (visual if no count)" })

-- Smart search
k.e("n", "n", h.smart_n, { desc = "next search result" })
k.e("n", "N", h.smart_N, { desc = "previous search result" })

-- Better indenting
k("v", "<", "<gv", { desc = "indent left and stay in visual mode" })
k("v", ">", ">gv", { desc = "indent right and stay in visual mode" })

-- Do not yank on x/c
k({ "n", "v" }, "x", '"_x', { desc = "delete without yanking" })
k({ "n", "v" }, "c", '"_c', { desc = "change without yanking" })

-- Better deletion
k.e("n", "dd", h.smart_dd, { desc = "no yank on empty" })

-- Replacer
k("n", "<leader>ar", r.replace_word_fast, { desc = "Replacer: all word" })
k("n", "<leader>aR", r.replace_word_confirm, { desc = "Replacer: tab to select word" })
