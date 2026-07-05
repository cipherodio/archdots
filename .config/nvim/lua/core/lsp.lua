vim.diagnostic.config({
    float = {
        border = "single",
        header = "",
        severity_sort = true,
        source = "if_many",
    },
    underline = false,
    signs = true,
    update_in_insert = false,
})

-- For performace and to stop color pop delay
-- Disable Semantic Tokens
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then
            client.server_capabilities.semanticTokensProvider = nil
            vim.lsp.document_color.enable(false, { bufnr = args.buf })
        end
    end,
})

-- Enable LSP
vim.lsp.enable({
    "lua_ls",
    "pylsp",
    "ruff",
    "rumdl",
    "bashls",
    "yamlls",
    "jsonls",
    "tombi",
})
