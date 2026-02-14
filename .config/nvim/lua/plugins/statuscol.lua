return {
    "luukvbaal/statuscol.nvim",
    branch = "0.10",
    opts = function()
        local builtin = require("statuscol.builtin")

        return {
            bt_ignore = { "nofile", "terminal" },
            relculright = true,
            clickhandlers = {
                Lnum = builtin.gitsigns_click,
            },
            segments = {
                -- Simulate signcolumn when gitsigns not in use
                {
                    sign = {
                        name = { ".*" },
                        namespace = { ".*" },
                        maxwidth = 1,
                        colwidth = 2,
                        auto = false,
                        wrap = true,
                    },
                },
                -- Line numbers
                {
                    text = { builtin.lnumfunc, " " },
                    colwidth = 1,
                    click = "v:lua.ScLa",
                },
                -- Folds
                {
                    text = { builtin.foldfunc, " " },
                    hl = "FoldColumn",
                    wrap = true,
                    colwidth = 1,
                    click = "v:lua.ScFa",
                },
                -- Gitsigns
                {
                    sign = {
                        name = { "GitSigns*" },
                        namespace = { "gitsigns" },
                        colwidth = 1,
                        -- fillchar = "▎",
                        fillchar = "┃",
                        fillcharhl = "Nrline",
                    },
                },
            },
        }
    end,
}
