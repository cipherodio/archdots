local opt = vim.opt
local g = vim.g

-- UI
opt.termguicolors = true
opt.background = "dark"
opt.number = true
opt.numberwidth = 4
opt.signcolumn = "no"
opt.laststatus = 3
opt.scrolloff = 2
opt.colorcolumn = "80"
opt.fillchars = {
    eob = " ",
    diff = " ",
    vert = "│",
    horiz = "─",
    stl = " ",
    stlnc = " ",
    wbr = " ",
}

-- Editor Behavior
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.confirm = true
opt.virtualedit = "block"
opt.formatoptions:remove("c", "r", "o")
opt.formatoptions:append("j", "n", "q")
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"
opt.wrap = false

-- Completion
opt.updatetime = 250
opt.timeoutlen = 300
opt.pumheight = 10
opt.completeopt = {
    "menuone",
    "noselect",
    "noinsert",
}

-- Command line
opt.showmode = false
opt.showcmd = false
opt.shortmess:append({
    W = true,
    F = true,
    S = true,
    C = true,
    I = true,
    c = true,
    s = true,
})

-- Tabs & Indentation
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.shiftround = true

-- Search & Substitution
opt.inccommand = "split"
opt.ignorecase = true
opt.smartcase = true
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"

-- Undo & Persistence
opt.undofile = true
opt.undolevels = 10000
opt.swapfile = false

-- Language & Spelll
opt.spelllang = { "en", "tl" }
opt.spellsuggest = "best,15"
opt.spellfile = {
    vim.fn.stdpath("config") .. "/spell/tl.utf-8.add",
    vim.fn.stdpath("config") .. "/spell/en.utf-8.add",
}

-- Folds
opt.foldenable = false
opt.foldmethod = "manual"
opt.foldlevel = 99

vim.lsp.set_log_level(vim.lsp.log_levels.OFF)

g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_perl_provider = 0
g.loaded_ruby_provider = 0
