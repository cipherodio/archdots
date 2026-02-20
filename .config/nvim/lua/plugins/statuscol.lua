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
                -- Left column: TODO signs
                {
                    sign = {
                        name = { ".*" },
                        namespace = { "todo-comments" },
                        maxwidth = 1,
                        colwidth = 2,
                        auto = false,
                        wrap = true,
                    },
                },
                -- Middle column: line numbers
                {
                    text = { builtin.lnumfunc, " " },
                    colwidth = 1,
                    click = "v:lua.ScLa",
                },
                -- Right column: Gitsigns
                {
                    sign = {
                        name = { "GitSigns*" },
                        namespace = { "gitsigns" },
                        colwidth = 1,
                        -- fillchar = "▎",
                        fillchar = "┃",
                        fillcharhl = "NrLine",
                    },
                },
            },
        }
    end,
}
