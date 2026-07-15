local o = vim.opt_local
local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set
---@param name string
---@return integer
local function augroup(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Options
o.spell = true
o.textwidth = 72
o.formatoptions = "jnq"

-- No spell for specific files
local nospell_files = {
    ["agenda.md"] = true,
}

if nospell_files[vim.fn.expand("%:t")] then
    vim.opt_local.spell = false
end

-- o.foldmethod = "expr"
-- o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- o.foldlevel = 0
-- o.foldlevelstart = 0
-- o.foldenable = true

-- Autocmds
-- Move current word as you type when reach the max textwidth
autocmd("TextChangedI", {
    desc = "Move current word to the next line at textwidth",
    group = augroup("nextline"),
    callback = require("fn.markdown").smart_textwidth,
    buffer = 0,
})

-- Keymaps
map("n", "<leader>mC", require("fn.markdown").toggle_conceal, {
    desc = "Markdown: toggle conceal",
    buffer = true,
    silent = true,
})

map("n", "<A-CR>", require("fn.markdown").toggle, {
    desc = "Markdown: toggle checkbox",
    buffer = true,
    silent = true,
})

map("n", "<S-CR>", require("fn.markdown").new_checkbox, {
    desc = "Markdown: new line checkbox",
    buffer = true,
    silent = true,
})

map("i", "<S-CR>", require("fn.markdown").new_checkbox, {
    desc = "Markdown: new line checkbox",
    buffer = true,
    silent = true,
})
