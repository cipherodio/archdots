vim.pack.add({
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", branch = "main" },
    { src = "https://github.com/andymass/vim-matchup" },
}, { confirm = false })

local k = require("utils.keyhelper")
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

-- Vim matchup
g.matchup_matchparen_offscreen = {}
g.matchup_matchparen_timeout = 300
g.matchup_matchparen_deferred = 1
g.matchup_matchline_statusline = 0
g.matchup_matchparen_statusbar = 0

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
