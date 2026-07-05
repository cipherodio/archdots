vim.pack.add({
    { src = "https://github.com/ellisonleao/gruvbox.nvim" },
}, { confirm = false })

require("gruvbox").setup({
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
    overrides = {
        -- Help
        ["@markup.link.vimdoc"] = { fg = "#83a598" },
        -- TodoQuickFix
        QuickFixLine = { fg = "NONE", bg = "NONE" },
        qfText = { fg = "#458588", bg = "NONE" },
        -- Cursor
        CursorLine = { fg = "NONE", bg = "NONE" },
        ColorColumn = { bg = "#504945" },
        -- Bash
        ["@string.special.path.bash"] = { fg = "#83a598" },
        -- Gitignore
        ["@string.special.path.gitignore"] = { fg = "#83a598" },
        -- Blink.cmp
        BlinkCmpDoc = { bg = "#3c3836" },
        -- Blink pairs
        MatchParen = { bg = "NONE", underline = false, bold = true },
        -- Markdown
        ["@markup.heading.1.markdown"] = { fg = "#fb4934", bold = true },
        ["@markup.heading.2.markdown"] = { fg = "#fe8019", bold = true },
        ["@markup.heading.3.markdown"] = { fg = "#fabd2f", bold = true },
        ["@markup.heading.4.markdown"] = { fg = "#b8bb26", bold = true },
        ["@markup.heading.5.markdown"] = { fg = "#8ec07c", bold = true },
        ["@markup.heading.6.markdown"] = { fg = "#83a598", bold = true },
        ["@markup.link.url.markdown"] = { fg = "#83a598", underline = false },
        ["@markup.link.markdown_inline"] = { fg = "#83a598", underline = false },
        ["@markup.link.url.markdown_inline"] = { fg = "#83a598", underline = false },
        ["@markup.strong.markdown_inline"] = { fg = "#83a598", bold = true },
        ["@markup.italic.markdown_inline"] = { fg = "#8ec07c", italic = true },
        SpellBad = { sp = "#fb4934", undercurl = true },
        StatusLine = { bg = "NONE" },
        WinBar = { bg = "NONE", fg = "#ebdbb2" },
        WinBarNC = { bg = "NONE", fg = "#ebdbb2" },
        -- Neogit context
        NeogitDiffContext = { fg = "#ebdbb2", bg = "NONE" },
        NeogitDiffContextHighlight = { fg = "#ebdbb2", bg = "NONE" },
        NeogitDiffContextCursor = { fg = "#ebdbb2", bg = "NONE" },
        -- Neogit add
        NeogitDiffAdd = { fg = "#b8bb26", bg = "NONE" },
        NeogitDiffAddHighlight = { fg = "#b8bb26", bg = "NONE" },
        NeogitDiffAddCursor = { fg = "#b8bb26", bg = "NONE" },
        NeogitDiffAddInline = { fg = "#1d2021", bg = "#98971a" },
        -- Neogit delete
        NeogitDiffDelete = { fg = "#fb4934", bg = "NONE" },
        NeogitDiffDeleteHighlight = { fg = "#fb4934", bg = "NONE" },
        NeogitDiffDeleteCursor = { fg = "#fb4934", bg = "NONE" },
        NeogitDiffDeleteInline = { fg = "#1d2021", bg = "#cc241d" },
        -- Neogit hunk header
        NeogitHunkHeader = { fg = "#83a598", bg = "NONE" },
        NeogitHunkHeaderHighlight = { fg = "#83a598", bg = "NONE" },
        NeogitHunkHeaderCursor = { fg = "#83a598", bg = "NONE" },
        -- Neogit change unstaged
        NeogitChangeDunstaged = { fg = "#fb4934", bg = "NONE" },
        -- Fold
        Folded = { bg = "NONE" },
    },
    dim_inactive = false,
    transparent_mode = true,
})

vim.cmd("colorscheme gruvbox")
