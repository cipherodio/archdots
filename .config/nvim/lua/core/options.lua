local o = vim.opt
local g = vim.g

o.termguicolors = true -- True color support
o.background = "dark" -- Dark highlight groups
o.number = true -- Absolute line numbers
o.signcolumn = "yes:1" -- Always show sign column
o.laststatus = 3 -- Global statusline
o.scrolloff = 2 -- Keeps 2 lines visible above & below when scrolling
o.colorcolumn = "80" --Visual ruler at column
o.fillchars = {
    eob = " ", -- remove "~" at end-of-buffer
    diff = " ", -- cleaner diff filler
    vert = "│", -- vertical split line character
    horiz = "─", -- horizontal split line character
    stl = " ", -- statusline fill character
    stlnc = " ", -- inactive statusline fill
    wbr = " ", -- window break char (rarely used)
}
o.mouse = "a" -- Enables mouse support
o.clipboard = "unnamedplus" -- System clipboard
o.splitbelow = true -- Horizontal splits open below
o.splitright = true -- Vertical splits open to the right
o.wrap = false -- Disables line wrapping
o.updatetime = 250 -- Faster CursorHold events
o.timeoutlen = 300 -- Time to wait for mapped sequence
o.showmode = false -- Disable INSERT/NORMAL mode text
o.showcmd = false -- Disable partial commands in command line
o.shortmess:append({
    W = true, -- suppress "written" messages
    F = true, -- reduce file info messages
    S = true, -- search messages cleaner
    C = true, -- completion messages reduced
    I = true, -- startup messages suppressed
    c = true, -- completion messages shortened
    s = true, -- search messages shortened
})
o.tabstop = 4 -- Number of spaces a tab character
o.softtabstop = 4 -- Number of spaces inserted when pressing TAB
o.shiftwidth = 4 -- Indent size for auto-indent and << >>
o.expandtab = true -- Convert tabs to spaces
o.smartindent = true -- Automatically indents new lines based on syntax
o.shiftround = true -- Rounds indentation to multiples of shiftwidth
o.inccommand = "split" -- Live preview of substitutions in a split window
o.ignorecase = true -- Case-insensitive search by default
o.smartcase = true -- Becomes case-sensitive if uppercase letters are used
o.grepprg = "rg --vimgrep" -- Uses ripgrep for :grep
o.grepformat = "%f:%l:%c:%m" -- Grep format results (file:line:col:message)
o.undofile = true -- Persistent undo across sessions
o.undolevels = 10000 -- Large undo history limit
o.swapfile = false -- Disables swap files
o.spelllang = { "en", "tl" } -- Enables spellcheck for English + Tagalog
o.spellsuggest = "best,15" -- Shows best 15 spelling suggestions
o.spellfile = {
    vim.fn.stdpath("config") .. "/spell/tl.utf-8.add",
    vim.fn.stdpath("config") .. "/spell/en.utf-8.add",
}
o.foldenable = false -- Folding disabled by default
o.foldmethod = "manual" -- Folds must be created manually
o.foldlevel = 99 -- Prevents automatic folding

vim.lsp.log.set_level(vim.lsp.log.levels.OFF) -- Disable LSP log spam
g.no_mail_maps = 1 -- Disables default mail keymaps
g.loaded_node_provider = 0 -- Disables NodeJS provider
g.loaded_python3_provider = 0 -- Disables Python 3 provider
g.loaded_perl_provider = 0 -- Disables Perl provider
g.loaded_ruby_provider = 0 -- Disables Ruby provider
