local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath,
    })

    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = { { import = "plugins" } },
    rocks = { enabled = false },
    -- concurrency = 1,
    git = { log = { "--since=3 days ago" }, timeout = 300 },
    -- install = { colorscheme = { "gruvbox-hard-contrast" } },
    checker = { enabled = true, notify = false },
    change_detection = { notify = false },
    diff = { cmd = "terminal_git" },
    ui = {
        icons = {
            cmd = "  ",
            config = "  ",
            event = "  ",
            ft = "  ",
            init = "  ",
            imports = "  ",
            keys = "  ",
            lazy = " ",
            loaded = " ",
            not_loaded = " ",
            plugin = "  ",
            runtime = "  ",
            require = "  ",
            source = " ",
            start = "",
            task = "  ",
        },
        title = "󰒲 Lazy.nvim",
        custom_keys = { false },
        border = "single",
        backdrop = 100,
        wrap = false,
        size = { width = 0.9, height = 0.9 },
    },
    performance = {
        rtp = {
            disabled_plugins = {
                -- "netrwPlugin",
                "tohtml",
                "tutor",
                "rplugin",
                "matchparen",
                "matchit",
            },
        },
    },
})
