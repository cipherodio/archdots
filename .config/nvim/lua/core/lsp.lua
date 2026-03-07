vim.diagnostic.config({
    -- virtual_lines = true,
    -- virtual_text = {
    --     prefix = "",
    --     format = function(diagnostic)
    --         local win = vim.api.nvim_get_current_win()
    --         local cfg = vim.api.nvim_win_get_config(win)
    --         return (cfg.relative ~= "") and diagnostic.message or "◾"
    --     end,
    -- },
    float = {
        border = "single",
        header = "",
        severity_sort = true,
        source = "if_many",
    },
    underline = false,
    severity_sort = true,
    signs = true,
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

-- NOTE: For performace and to stop color pop delay
-- Disable Semantic Tokens
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then
            client.server_capabilities.semanticTokensProvider = nil
        end
    end,
})
