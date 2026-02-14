local opt = vim.opt
local g = vim.g

-- Miscellaneous
opt.termguicolors = true
opt.background = "dark"
opt.mouse = ""
opt.updatetime = 200
opt.fillchars = [[eob: ,fold: ,foldopen:󰅀,foldsep: ,foldclose:󰅂,diff: ]]
opt.shortmess = "ltToOCFIc"
opt.clipboard = "unnamedplus"
opt.wrap = false
-- Splits
opt.splitbelow = true
opt.splitright = true
-- Spell, needs netrw, uncomment opt.spell to auto download spell file
-- opt.spell = true
opt.spelllang = { "en", "tl" }
opt.spellsuggest = "best,9"
opt.spellfile = vim.fn.stdpath("config") .. "/spell/words.utf-8.add"
-- opt.spelloptions = "camel"
-- Completion
-- opt.complete = ".,o"
opt.completeopt = "menuone,popup,noselect,noinsert,fuzzy"
opt.pumheight = 10
opt.wildoptions = "pum,tagfile,fuzzy"
-- Command line
opt.cmdheight = 1
opt.showmode = false -- disables INSERT, VISUAL
opt.showcmd = false -- disables partial command letters
-- History
opt.swapfile = false
opt.undofile = true
opt.undolevels = 10000
-- Cursor
opt.cursorline = true
opt.cursorlineopt = "number"
-- Statuscolumn
opt.number = true
opt.numberwidth = 2
-- Indentation
opt.expandtab = true
opt.smartindent = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.shiftround = true
-- Folds
opt.foldlevel = 99
opt.foldlevelstart = 99
-- opt.foldcolumn = "1"
opt.foldenable = true
opt.foldmethod = "indent"
opt.foldtext = ""

vim.lsp.set_log_level(vim.lsp.log_levels.OFF)

g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
