vim.pack.add({
    { src = "https://github.com/ellisonleao/gruvbox.nvim" },
}, { confirm = false })

local function apply_theme()
    vim.o.background = require("fn.theme").mode()

    local c = require("fn.colors").current()

    local opts = {
        terminal_colors = true,
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
            strings = false,
            emphasis = false,
            comments = false,
            operators = false,
            folds = false,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        inverse = true,
        contrast = "hard",
        dim_inactive = false,
        transparent_mode = true,
    }
    opts.overrides = {
        SignColumn = { bg = "NONE" },
        -- Help
        ["@markup.link.vimdoc"] = { fg = c.c12 },
        -- TodoQuickFix
        QuickFixLine = { fg = "NONE", bg = "NONE" },
        qfText = { fg = c.c04, bg = "NONE" },
        -- Cursor
        CursorLine = { fg = "NONE", bg = "NONE" },
        ColorColumn = { bg = c.c17 },
        -- Folds
        Folded = { bg = "NONE" },
        -- Bash
        ["@string.special.path.bash"] = { fg = c.c12 },
        -- Gitignore
        ["@string.special.path.gitignore"] = { fg = c.c12 },
        -- Tabs
        TabLine = { bg = "NONE" },
        TabLineSel = { bg = "NONE" },
        TabLineFill = { bg = "NONE" },
        -- Blink.cmp
        BlinkCmpDoc = { bg = c.c16 },
        -- Blink pairs
        MatchParen = { bg = "NONE", bold = true },
        -- Markdown
        ["@markup.heading.1.markdown"] = { fg = c.c09, bold = true },
        ["@markup.heading.2.markdown"] = { fg = c.c18, bold = true },
        ["@markup.heading.3.markdown"] = { fg = c.c11, bold = true },
        ["@markup.heading.4.markdown"] = { fg = c.c10, bold = true },
        ["@markup.heading.5.markdown"] = { fg = c.c14, bold = true },
        ["@markup.heading.6.markdown"] = { fg = c.c12, bold = true },
        ["@markup.link.url.markdown"] = { fg = c.c12, underline = false },
        ["@markup.link.markdown_inline"] = { fg = c.c12, underline = false },
        ["@markup.link.url.markdown_inline"] = { fg = c.c12, underline = false },
        ["@markup.strong.markdown_inline"] = { fg = c.c12, bold = true },
        ["@markup.italic.markdown_inline"] = { fg = c.c14, italic = true },
        -- Spell
        SpellBad = { sp = c.c09, undercurl = true },
        -- Statusline
        StatusLine = { bg = "NONE" },
        -- Winbar
        WinBar = { bg = "NONE", fg = c.c15 },
        WinBarNC = { bg = "NONE", fg = c.c15 },
        -- Neogit context
        NeogitDiffContext = { fg = c.c15, bg = "NONE" },
        NeogitDiffContextHighlight = { fg = c.c15, bg = "NONE" },
        NeogitDiffContextCursor = { fg = c.c15, bg = "NONE" },
        -- Neogit add
        NeogitDiffAdd = { fg = c.c10, bg = "NONE" },
        NeogitDiffAddHighlight = { fg = c.c10, bg = "NONE" },
        NeogitDiffAddCursor = { fg = c.c10, bg = "NONE" },
        NeogitDiffAddInline = { fg = c.bg, bg = c.c02 },
        -- Neogit delete
        NeogitDiffDelete = { fg = c.c09, bg = "NONE" },
        NeogitDiffDeleteHighlight = { fg = c.c09, bg = "NONE" },
        NeogitDiffDeleteCursor = { fg = c.c09, bg = "NONE" },
        NeogitDiffDeleteInline = { fg = c.bg, bg = c.c01 },
        -- Neogit hunk header
        NeogitHunkHeader = { fg = c.c12, bg = "NONE" },
        NeogitHunkHeaderHighlight = { fg = c.c12, bg = "NONE" },
        NeogitHunkHeaderCursor = { fg = c.c12, bg = "NONE" },
        -- Neogit change unstaged
        NeogitChangeDunstaged = { fg = c.c09, bg = "NONE" },
        -- Neogit change staged
        NeogitChangeDstaged = { fg = c.c09, bg = "NONE" },
        -- Whichkey
        WhichKeyNormal = { bg = opts.transparent_mode and "NONE" or c.bg },
        WhichKeyBorder = { bg = opts.transparent_mode and "NONE" or c.bg },
    }

    require("gruvbox").setup(opts)

    vim.cmd.colorscheme("gruvbox")
end

apply_theme()

vim.api.nvim_create_autocmd("Signal", {
    desc = "Reload after system theme change",
    group = vim.api.nvim_create_augroup("reload_theme", { clear = true }),
    pattern = "SIGUSR1",
    callback = function()
        apply_theme()
        vim.cmd("redraw!")
    end,
})
