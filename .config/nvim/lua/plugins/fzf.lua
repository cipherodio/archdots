return {
    {
        "ibhagwan/fzf-lua",
        cmd = { "FzfLua" },
        dependencies = "nvim-tree/nvim-web-devicons",
        keys = {
            {
                "<leader>ff",
                function()
                    require("fzf-lua").files()
                end,
                desc = "Files",
            },
            {
                "<leader>gf",
                function()
                    require("fzf-lua").git_files()
                end,
                desc = "Git files",
            },
            {
                "<leader>gi",
                function()
                    require("fzf-lua").git_status()
                end,
                desc = "Info/status",
            },
            {
                "<leader>gt",
                function()
                    require("fzf-lua").git_commits()
                end,
                desc = "Check git commits",
            },
            {
                "<leader>gb",
                function()
                    require("fzf-lua").git_branches()
                end,
                desc = "Branches",
            },
            {
                "<leader>fw",
                function()
                    require("fzf-lua").live_grep()
                end,
                desc = "Project live grep",
            },
            {
                "<leader>fo",
                function()
                    require("fzf-lua").oldfiles()
                end,
                desc = "Recent files",
            },
            {
                "<leader><tab><tab>",
                function()
                    require("fzf-lua").buffers()
                end,
                desc = "Buffers",
            },
            {
                "<leader>fk",
                function()
                    require("fzf-lua").keymaps()
                end,
                desc = "Keymaps",
            },
            {
                "<leader>la",
                function()
                    require("fzf-lua").lsp_code_actions()
                end,
                desc = "Actions",
            },
            {
                "<leader>ls",
                function()
                    require("fzf-lua").lsp_document_symbols()
                end,
                desc = "Symbol lsp document",
            },
            {
                "<leader>ld",
                function()
                    require("fzf-lua").diagnostics_document()
                end,
                desc = "Document diagnostics",
            },
            {
                "<leader>lw",
                function()
                    require("fzf-lua").diagnostics_workspace()
                end,
                desc = "Workspace diagnostics",
            },
            {
                "<leader>fh",
                function()
                    require("fzf-lua").helptags()
                end,
                desc = "Help",
            },
            {
                "<leader>fC",
                function()
                    require("fzf-lua").commands()
                end,
                desc = "Commands",
            },
            {
                "<leader>fc",
                function()
                    require("fzf-lua").command_history()
                end,
                desc = "Command history",
            },
            {
                "<leader>fr",
                function()
                    require("fzf-lua").registers()
                end,
                desc = "Registers",
            },
            {
                "<leader>fm",
                function()
                    require("fzf-lua").manpages()
                end,
                desc = "Man pages",
            },
            {
                "<leader>fx",
                function()
                    require("fzf-lua").files({ cwd = "~/" })
                end,
                desc = "Home search",
            },
            {
                "<leader>fX",
                function()
                    require("fzf-lua").files({ cwd = "~/.local/" })
                end,
                desc = "Local search",
            },
            {
                "<leader>fn",
                function()
                    require("fzf-lua").files({ cwd = "~/hub/src/mdnotes/" })
                end,
                desc = "Notes in markdown",
            },
        },
        opts = {
            winopts = {
                border = "single",
                row = 0.55,
                col = 0.50,
                backdrop = 100,
                preview = {
                    hidden = false, -- disables/enables previewer
                    scrollbar = false,
                    title_pos = "left",
                    layout = "vertical",
                    vertical = "down:70%",
                },
            },
            fzf_opts = { ["--separator"] = " " },
            files = { prompt = "   Files: " },
            git = {
                files = { prompt = "   Git Files" },
                status = { prompt = "   Git Status" },
                commits = { prompt = "   Git Commits" },
                branches = { prompt = "   Git Branch" },
            },
            grep = { prompt = "   Grep Word " },
            oldfiles = { prompt = "   Recent Files " },
            buffers = { prompt = "   Buffers " },
            keymaps = { prompt = "   Keymaps " },
            lsp = {
                code_actions = { prompt = "   Code Actions " },
                symbols = { prompt = "   Lsp document symbols " },
            },
            diagnostics = { prompt = "   Diagnostics " },
            helptags = { prompt = "  Help " },
            command = { prompt = "   Commands " },
            command_history = { prompt = "   Command History " },
            registers = { prompt = "   Registers " },
            manpages = { rompt = "  Man Pages " },
        },
    },
    {
        "otavioschwanck/fzf-lua-explorer.nvim",
        dependencies = { "ibhagwan/fzf-lua" },
        keys = {
            {
                "<leader>fb",
                function()
                    require("fzf-lua-explorer").explorer()
                end,
                desc = "File browser",
            },
        },
    },
}
