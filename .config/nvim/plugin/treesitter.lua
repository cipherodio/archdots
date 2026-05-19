vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
    { src = "https://github.com/andymass/vim-matchup" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
}, { confirm = false })

local k = require("utils.keyhelper")
local t = require("nvim-treesitter")
local tc = require("treesitter-context")
local g = vim.g

local parsers = {
    "bash",
    "commonlisp",
    "c",
    "cpp",
    "css",
    "diff",
    "gitcommit",
    "gitignore",
    "git_config",
    "git_rebase",
    "html",
    "ini",
    "javascript",
    "jsdoc",
    "json",
    "lua",
    "luadoc",
    "luap",
    "markdown",
    "markdown_inline",
    "printf",
    "python",
    "query",
    "rasi",
    "ssh_config",
    "tmux",
    "toml",
    "typescript",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
    "zathurarc",
}

-- Bootstrap
local m = vim.fn.stdpath("state") .. "/treesitter_bootstrap_done"

if vim.fn.filereadable(m) == 0 then
    vim.schedule(function()
        vim.cmd("silent! TSInstall " .. table.concat(parsers, " "))
        vim.fn.writefile({ "done" }, m)
    end)
end

-- Treesitter
t.setup({
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
    },
    matchup = {
        enable = true,
        include_match_words = true,
        enable_quotes = true,
    },
})

-- Vim matchup
g.matchup_matchparen_offscreen = {}
g.matchup_matchparen_timeout = 300
g.matchup_matchparen_deferred = 1
g.matchup_matchline_statusline = 0
g.matchup_matchparen_statusbar = 0

-- Treesitter context
tc.setup({
    enable = true,
    max_lines = 1,
    line_numbers = true,
    mode = "cursor",
})

-- Filetype start
vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        pcall(vim.treesitter.start)
    end,
})

-- Keymaps
k("n", "<leader>tu", function()
    vim.notify("Updating Treesitter parsers...", vim.log.levels.INFO)
    vim.cmd("TSUpdate")
end, { desc = "Treesitter: update parsers" })
