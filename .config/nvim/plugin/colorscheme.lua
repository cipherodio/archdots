vim.pack.add({
    { src = "https://github.com/ellisonleao/gruvbox.nvim" },
}, { confirm = false })

local theme = require("fn.theme")

local palettes = {
    dark = {
        background = "#1d2021",
        foreground = "#ebdbb2",
        surface = "#3c3836",
        color_column = "#504945",
        inverse_foreground = "#1d2021",

        red = "#fb4934",
        red_dim = "#cc241d",
        orange = "#fe8019",
        yellow = "#fabd2f",
        green = "#b8bb26",
        green_dim = "#98971a",
        aqua = "#8ec07c",
        blue = "#83a598",
        blue_dim = "#458588",
    },

    light = {
        background = "#fbf1c7",
        foreground = "#3c3836",
        surface = "#ebdbb2",
        color_column = "#d5c4a1",
        inverse_foreground = "#f9f5d7",

        red = "#9d0006",
        red_dim = "#cc241d",
        orange = "#af3a03",
        yellow = "#b57614",
        green = "#79740e",
        green_dim = "#98971a",
        aqua = "#427b58",
        blue = "#076678",
        blue_dim = "#458588",
    },
}

local function apply_theme()
    local mode = theme.mode()
    local colors = palettes[mode]

    if not colors then
        vim.notify(("Invalid Gruvbox theme mode: %s"):format(mode), vim.log.levels.ERROR)
        return
    end

    vim.o.background = mode

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
            -- Normal = { fg = colors.foreground, bg = colors.background },
            -- NormalNC = { fg = colors.foreground, bg = colors.background },
            Normal = { fg = colors.foreground, bg = "NONE" },
            NormalNC = { fg = colors.foreground, bg = "NONE" },
            -- SignColumn = { bg = colors.background },
            SignColumn = { bg = "NONE" },
            -- CursorLineSign = { bg = colors.background },
            CursorLineSign = { bg = "NONE" },
            -- LineNr = { bg = colors.background },
            LineNr = { bg = "NONE" },
            CursorLineNr = { bg = colors.background },
            -- Help
            ["@markup.link.vimdoc"] = { fg = colors.blue },
            -- TodoQuickFix
            QuickFixLine = { fg = "NONE", bg = "NONE" },
            qfText = { fg = colors.blue_dim, bg = "NONE" },
            -- Cursor
            CursorLine = { fg = "NONE", bg = "NONE" },
            ColorColumn = { bg = colors.color_column },
            -- Bash
            ["@string.special.path.bash"] = { fg = colors.blue },
            -- Gitignore
            ["@string.special.path.gitignore"] = { fg = colors.blue },
            -- Tabs
            TabLine = { bg = "NONE" },
            TabLineSel = { bg = "NONE" },
            TabLineFill = { bg = "NONE" },
            -- Blink.cmp
            BlinkCmpDoc = { bg = colors.surface },
            -- Blink pairs
            MatchParen = { bg = "NONE", underline = false, bold = true },
            -- Markdown
            ["@markup.heading.1.markdown"] = { fg = colors.red, bold = true },
            ["@markup.heading.2.markdown"] = { fg = colors.orange, bold = true },
            ["@markup.heading.3.markdown"] = { fg = colors.yellow, bold = true },
            ["@markup.heading.4.markdown"] = { fg = colors.green, bold = true },
            ["@markup.heading.5.markdown"] = { fg = colors.aqua, bold = true },
            ["@markup.heading.6.markdown"] = { fg = colors.blue, bold = true },
            ["@markup.link.url.markdown"] = { fg = colors.blue, underline = false },
            ["@markup.link.markdown_inline"] = { fg = colors.blue, underline = false },
            ["@markup.link.url.markdown_inline"] = { fg = colors.blue, underline = false },
            ["@markup.strong.markdown_inline"] = { fg = colors.blue, bold = true },
            ["@markup.italic.markdown_inline"] = { fg = colors.aqua, italic = true },
            -- Spell
            SpellBad = { sp = colors.red, undercurl = true },
            -- Statusline
            StatusLine = { bg = "NONE" },
            -- Winbar
            WinBar = { bg = "NONE", fg = colors.foreground },
            WinBarNC = { bg = "NONE", fg = colors.foreground },
            -- Neogit context
            NeogitDiffContext = { fg = colors.foreground, bg = "NONE" },
            NeogitDiffContextHighlight = { fg = colors.foreground, bg = "NONE" },
            NeogitDiffContextCursor = { fg = colors.foreground, bg = "NONE" },
            -- Neogit add
            NeogitDiffAdd = { fg = colors.green, bg = "NONE" },
            NeogitDiffAddHighlight = { fg = colors.green, bg = "NONE" },
            NeogitDiffAddCursor = { fg = colors.green, bg = "NONE" },
            NeogitDiffAddInline = {
                fg = colors.inverse_foreground,
                bg = colors.green_dim,
            },
            -- Neogit delete
            NeogitDiffDelete = { fg = colors.red, bg = "NONE" },
            NeogitDiffDeleteHighlight = { fg = colors.red, bg = "NONE" },
            NeogitDiffDeleteCursor = { fg = colors.red, bg = "NONE" },
            NeogitDiffDeleteInline = {
                fg = colors.inverse_foreground,
                bg = colors.red_dim,
            },
            -- Neogit hunk header
            NeogitHunkHeader = { fg = colors.blue, bg = "NONE" },
            NeogitHunkHeaderHighlight = { fg = colors.blue, bg = "NONE" },
            NeogitHunkHeaderCursor = { fg = colors.blue, bg = "NONE" },
            -- Neogit change unstaged
            NeogitChangeDunstaged = { fg = colors.red, bg = "NONE" },
            -- Fold
            Folded = { bg = "NONE" },
        },

        dim_inactive = false,
        transparent_mode = true,
    })

    vim.cmd.colorscheme("gruvbox")
end

apply_theme()

vim.api.nvim_create_autocmd("Signal", {
    desc = "Reload Gruvbox after system theme change",
    group = vim.api.nvim_create_augroup("reload_gruvbox_theme", { clear = true }),
    pattern = "SIGUSR1",
    callback = function()
        apply_theme()
        vim.cmd("redraw!")
    end,
    -- callback = apply_theme,
})
