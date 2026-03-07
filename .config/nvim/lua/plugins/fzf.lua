return {
    "ibhagwan/fzf-lua",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
        {
            "<leader>ff",
            function()
                require("fzf-lua").files({ cwd = vim.fn.expand("%:p:h") })
            end,
            desc = "Fzf: files",
        },
        {
            "<leader>gf",
            function()
                require("utils.fzfgithelper").smart_git("git_files")
            end,
            desc = "Fzf: Git files",
        },
        {
            "<leader>gs",
            function()
                require("utils.fzfgithelper").smart_git("git_status")
            end,
            desc = "Fzf: status",
        },
        {
            "<leader>gc",
            function()
                require("utils.fzfgithelper").smart_git("git_commits")
            end,
            desc = "Fzf: show Git commits",
        },
        {
            "<leader>gC",
            function()
                require("utils.fzfgithelper").smart_git("git_bcommits")
            end,
            desc = "Fzf: buffer commits",
        },
        {
            "<leader>gb",
            function()
                require("utils.fzfgithelper").smart_git("git_branches")
            end,
            desc = "Fzf: branches",
        },
        {
            "<leader>fw",
            function()
                require("utils.fzfgithelper").smart_git("live_grep")
            end,
            desc = "Fzf: project smart live grep",
        },
        {
            "<leader>fo",
            function()
                require("fzf-lua").oldfiles()
            end,
            desc = "Fzf: recent files",
        },
        {
            "<leader>fb",
            function()
                require("fzf-lua").buffers()
            end,
            desc = "Fzf: buffers",
        },
        {
            "<leader>fk",
            function()
                require("fzf-lua").keymaps()
            end,
            desc = "Fzf: keymaps",
        },
        {
            "<leader>la",
            function()
                require("fzf-lua").lsp_code_actions()
            end,
            desc = "Fzf: code actions",
        },
        {
            "<leader>ls",
            function()
                require("fzf-lua").lsp_document_symbols()
            end,
            desc = "Fzf: symbol LSP document",
        },
        {
            "<leader>ld",
            function()
                require("fzf-lua").diagnostics_document()
            end,
            desc = "Fzf: document diagnostics",
        },
        {
            "<leader>lw",
            function()
                require("fzf-lua").diagnostics_workspace()
            end,
            desc = "Fzf: workspace diagnostics",
        },
        {
            "<leader>fh",
            function()
                require("fzf-lua").helptags()
            end,
            desc = "Fzf: help",
        },
        {
            "<leader>fC",
            function()
                require("fzf-lua").commands()
            end,
            desc = "Fzf: commands",
        },
        {
            "<leader>fc",
            function()
                require("fzf-lua").command_history()
            end,
            desc = "Fzf: command history",
        },
        {
            "<leader>fr",
            function()
                require("fzf-lua").registers()
            end,
            desc = "Fzf: registers",
        },
        {
            "<leader>fm",
            function()
                require("fzf-lua").manpages()
            end,
            desc = "Fzf: man pages",
        },
        {
            "<leader>fx",
            function()
                require("fzf-lua").files({ cwd = "~/" })
            end,
            desc = "Fzf: home search",
        },
        {
            "<leader>fX",
            function()
                require("fzf-lua").files({
                    cmd = "fd -tf -I -E .git . review src",
                    cwd = "~/hub",
                })
            end,
            desc = "Fzf: hub search",
        },
        {
            "<leader>fn",
            function()
                require("fzf-lua").files({ cwd = "~/hub/src/mdnotes/" })
            end,
            desc = "Fzf: notes in markdown",
        },
        {
            "<leader>fN",
            function()
                require("fzf-lua").live_grep({ cwd = "~/hub/src/mdnotes/" })
            end,
            desc = "Fzf: grep in notes",
        },
    },
    opts = {
        register_ui_select = true,
        winopts = {
            border = "single",
            row = 0.55,
            col = 0.50,
            backdrop = 100,
            preview = {
                hidden = false,
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
        grep = {
            prompt = "   Grep Word ",
            multiprocess = true,
            rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
        },
        -- grep = { prompt = "   Grep Word " },
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
        manpages = { prompt = "  Man Pages " },
    },
    config = function(_, opts)
        local fzflua = require("fzf-lua")
        fzflua.setup(opts)
        fzflua.register_ui_select()
    end,
}
