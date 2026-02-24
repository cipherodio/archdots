local opt = vim.opt
local g = vim.g

-- General
opt.termguicolors = true
opt.background = "dark"
opt.mouse = ""
opt.fillchars = [[eob: ,fold: ,foldopen:󰅀,foldsep: ,foldclose:󰅂,diff: ]]
opt.shortmess = "ltToOCFIc"
opt.clipboard = "unnamedplus"
opt.wrap = false
opt.scrolloff = 8
opt.colorcolumn = "80"
opt.laststatus = 3
opt.showbreak = "↳"

opt.showmode = false
opt.showcmd = false

opt.updatetime = 50
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 10

opt.number = true
opt.numberwidth = 2
opt.signcolumn = "yes"

opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true
opt.shiftround = true

opt.foldenable = false
opt.foldmethod = "manual"
opt.foldlevel = 99

opt.incsearch = true
opt.inccommand = "split"
opt.ignorecase = true
opt.smartcase = true

opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undolevels = 10000

opt.splitbelow = true
opt.splitright = true

opt.spelllang = { "en", "tl" }
opt.spellsuggest = "best,9"
opt.spellfile = {
    vim.fn.stdpath("config") .. "/spell/tl.utf-8.add",
    vim.fn.stdpath("config") .. "/spell/en.utf-8.add",
}

vim.lsp.set_log_level(vim.lsp.log_levels.OFF)

g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
