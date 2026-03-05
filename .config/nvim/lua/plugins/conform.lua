return {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        format_on_save = function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
            end
            return {
                timeout_ms = 3000,
                lsp_fallback = true,
            }
        end,
        formatters_by_ft = {
            lua = { "stylua" },
            sh = { "shfmt", "shellcheck" },
            zsh = { "shellcheck" },
            python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
            markdown = { "markdown-toc", "prettier" },
        },
        formatters = {
            prettier = {
                -- NOTE: For prettier not working on some directories
                cwd = function(_, ctx)
                    local root = vim.fs.find(
                        { ".git", "package.json", ".prettierrc" },
                        { upward = true, path = ctx.dirname }
                    )[1]
                    return root and vim.fn.fnamemodify(root, ":h") or ctx.dirname
                end,
                prepend_args = {
                    "--config",
                    vim.fn.expand("~/.config/prettier/.prettierrc"),
                },
            },
            ["markdown-toc"] = {
                condition = function(_, ctx)
                    for _, line in
                        ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false))
                    do
                        if line:find("<!%-%- toc %-%->") then
                            return true
                        end
                    end
                    return false
                end,
                args = {
                    "--indent",
                    "    ",
                    "-i",
                    "$FILENAME",
                    "--bullets",
                    "-",
                },
            },
        },
    },
}
