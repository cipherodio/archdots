local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Disable macro recording key
map("n", "q", "<nop>", { silent = true })

-- Clear search highlight on Escape
map("n", "<esc>", require("fn.util").smart_esc, { silent = true, expr = true })

-- Inspect
map("n", "<leader>i", "<cmd>Inspect<cr>", { desc = "Inspect", silent = true })

-- Check plugin updates, do gra inside to delete a plugin then :w
-- map("n", "<leader>pu", require("fn.util").plugin_stats, {
--     desc = "Plugins: check status",
--     silent = true,
-- })
-- map("n", "<leader>pu", vim.pack.update, { desc = "Plugin: updates" })
map("n", "<leader>pu", function()
    vim.pack.update()
end, { desc = "Plugin: update" })

-- Notes
map("n", "<leader>mf", require("fn.markdown").open_agenda, {
    desc = "Markdown: open agenda",
    silent = true,
})

-- Balance inquiry
map("n", "<leader>ab", require("fn.util").check_deepseek_balance, {
    desc = "AI: check balance",
    silent = true,
})

-- Undo all changes
map("n", "<leader>wr", "<cmd>e!<cr>", { desc = "Undo all changes", silent = true })

-- Delete all text
map("n", "<leader>wd", "<cmd>%d<cr>", { desc = "Delete all text", silent = true })

-- Write files
map("n", "<leader>ww", "<cmd>w<cr>", { desc = "Save", silent = true })
map("n", "<leader>wa", "<cmd>wa<cr>", { desc = "Save all buffer", silent = true })
map("n", "<leader>wq", "<cmd>wq<cr>", { desc = "Save and quit", silent = true })
map("n", "<leader>wn", require("fn.util").create_and_open, {
    desc = "New file in cwd",
    silent = true,
})
map("n", "<leader>wt", require("fn.util").create_on_disk, {
    desc = "Touch in cwd",
    silent = true,
})

-- Quit
map("n", "<leader>qq", "<cmd>q!<cr>", { desc = "Quit without save", silent = true })
map("n", "<leader>qa", "<cmd>qa<cr>", { desc = "Quit all", silent = true })
map("n", "<leader>qd", "<cmd>q<cr>", { desc = "Quit current window", silent = true })
map("n", "<leader>qs", "<cmd>bd<cr>", { desc = "Quit current buffer", silent = true })

-- Yank inside single and double quotes
map("n", "<leader>yd", 'yi"', { desc = "Yank double quote", silent = true, remap = true })
map("n", "<leader>ys", "yi'", { desc = "Yank single quote", silent = true, remap = true })

-- Tabs
-- map("n", "<M-h>", "<cmd>tabnext<cr>", { desc = "Tab next" })
-- map("n", "<M-l>", "<cmd>tabprevious<cr>", { desc = "Tab previous" })

-- Buffers
map("n", "L", "<cmd>bnext<cr>", { desc = "Buffer: next", silent = true })
map("n", "H", "<cmd>bprevious<cr>", { desc = "Buffer: previous", silent = true })
map("n", "<leader>bv", "<cmd>vnew<cr>", { desc = "Split: new vertical", silent = true })
map("n", "<leader>bh", "<cmd>new<cr>", { desc = "Split: new horizontal", silent = true })
map("n", "<leader>bV", "<cmd>vsplit<cr>", { desc = "Split: vertical", silent = true })
map("n", "<leader>bH", "<cmd>split<cr>", { desc = "Split: horizontal", silent = true })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "move to left window", silent = true })
map("n", "<C-j>", "<C-w>j", { desc = "move to lower window", silent = true })
map("n", "<C-k>", "<C-w>k", { desc = "move to upper window", silent = true })
map("n", "<C-l>", "<C-w>l", { desc = "move to right window", silent = true })

-- LSP
map("n", "<leader>lo", require("fn.lsp").show_root_dir, {
    desc = "LSP: show root directory",
    silent = true,
})
map("n", "<leader>lc", require("fn.lsp").toggle_codelens, {
    desc = "LSP: toggle codelens",
    silent = true,
})
map("n", "<leader>li", require("fn.lsp").toggle_inlay_hints, {
    desc = "LSP: toggle inlay hints",
    silent = true,
})
map("n", "<leader>lr", require("fn.lsp").rename, {
    desc = "LSP: rename symbol",
    silent = true,
})
map("n", "<leader>lf", require("fn.lsp").toggle_autoformat, {
    desc = "Format: toggle",
    silent = true,
})
map("n", "]d", require("fn.lsp").diag_next, {
    desc = "LSP: next diagnostic",
    silent = true,
})
map("n", "[d", require("fn.lsp").diag_prev, {
    desc = "LSP: previous diagnostic",
    silent = true,
})

-- Spell
map("n", "<leader>sS", require("fn.spell").toggle_spell, {
    desc = "Spell: Toggle spell",
    silent = true,
})

map({ "n", "v" }, "zg", require("fn.spell").spell_add_lower(1), {
    desc = "Spell: add tagalog",
    silent = true,
})
map({ "n", "v" }, "<leader>st", require("fn.spell").spell_add_lower(1), {
    desc = "Spell: add tagalog",
    silent = true,
})
map({ "n", "v" }, "<leader>se", require("fn.spell").spell_add_lower(2), {
    desc = "Spell: add english",
    silent = true,
})
map({ "n", "v" }, "<leader>sT", require("fn.spell").smart_spell(1), {
    desc = "Spell: undo spell tagalog",
    silent = true,
})
map({ "n", "v" }, "<leader>sE", require("fn.spell").smart_spell(2), {
    desc = "Spell: undo spell english",
    silent = true,
})
map("n", "<leader>sc", require("fn.spell").clean_spell_files, {
    desc = "Spell: clean spell file",
    silent = true,
})
map("n", "<leader>sr", require("fn.spell").report_stats, {
    desc = "Spell: report writing stats",
    silent = true,
})
map("n", "<leader>sl", require("fn.spell").fzf_spell_all, {
    desc = "Fzf: list all spell errors",
    silent = true,
})
map("n", "<leader>sn", "]s", { desc = "Next spelling error", silent = true })
map("n", "<leader>sp", "[s", { desc = "Previous spelling error", silent = true })

-- Move lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "move line down", silent = true })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "move line up", silent = true })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "move line down", silent = true })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "move line up", silent = true })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "move selection down", silent = true })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "move selection up", silent = true })

-- Smart navigation
map("n", "j", require("fn.util").smart_j, {
    desc = "move down (visual if no count)",
    silent = true,
    expr = true,
})
map("n", "k", require("fn.util").smart_k, {
    desc = "move up (visual if no count)",
    silent = true,
    expr = true,
})

-- Smart search
map("n", "n", require("fn.util").smart_n, {
    desc = "next search result",
    silent = true,
    expr = true,
})
map("n", "N", require("fn.util").smart_N, {
    desc = "previous search result",
    silent = true,
    expr = true,
})

-- Better indenting
map("v", "<", "<gv", { desc = "indent left and stay in visual mode", silent = true })
map("v", ">", ">gv", { desc = "indent right and stay in visual mode", silent = true })

-- Do not yank on x/c
map({ "n", "v" }, "x", '"_x', { desc = "delete without yanking", silent = true })
map({ "n", "v" }, "c", '"_c', { desc = "change without yanking", silent = true })

-- Better deletion
map("n", "dd", require("fn.util").smart_dd, {
    desc = "no yank on empty",
    silent = true,
    expr = true,
})

-- Replacer
map("n", "<leader>ar", require("fn.replacer").replace_word_fast, {
    desc = "Replacer: all word",
    silent = true,
})
map("n", "<leader>aR", require("fn.replacer").replace_word_confirm, {
    desc = "Replacer: tab to select word",
    silent = true,
})
