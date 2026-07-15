vim.pack.add({
    { src = "https://github.com/stevearc/conform.nvim" },
}, { confirm = false })

require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt", "shellcheck" },
        zsh = { "shellcheck" },
        python = { "ruff_fix", "ruff_organize_imports", "ruff_format" },
        markdown = { "rumdl" },
        xml = { "xmlstarlet" },
    },
    format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end

        local opts = {
            timeout_ms = 3000,
            lsp_fallback = true,
        }

        if vim.bo[bufnr].filetype == "css" then
            opts.formatting_options = {
                wrapLineLength = 80,
                preserveNewLines = true,
                maxPreserveNewLines = 2,
            }
        end

        return opts
    end,
})
