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
            markdown = { "rumdl" },
            xml = { "xmlstarlet" },
        },
    },
}
