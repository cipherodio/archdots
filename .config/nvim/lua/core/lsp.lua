local function augroup(name)
    return vim.api.nvim_create_augroup("user_" .. name, { clear = true })
end

local default_mappings = {
    -- { keys = "<leader>ca", func = vim.lsp.buf.code_action, desc = "Code Actions" },
    {
        keys = "<leader>lk",
        func = vim.lsp.buf.hover,
        desc = "Hover Documentation",
        has = "hoverProvider",
    },
    {
        keys = "<leader>lK",
        func = vim.lsp.buf.hover,
        desc = "Hover (alt)",
        has = "hoverProvider",
    },
    {
        keys = "<leader>lD",
        func = vim.lsp.buf.definition,
        desc = "Goto Definition",
        has = "definitionProvider",
    },
}

local completion = vim.g.completion_mode or "blink" -- or 'native'
vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup("lsp_attach"),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local buf = args.buf
        if client then
            -- Built-in completion
            if
                completion == "native"
                and client:supports_method("textDocument/completion")
            then
                vim.lsp.completion.enable(
                    true,
                    client.id,
                    args.buf,
                    { autotrigger = true }
                )
            end

            -- Inlay hints (i prefered this to be toggled for now)
            -- if client:supports_method("textDocument/inlayHints") then
            --     vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
            -- end

            -- Keeping it here in case i moved to neovim v0.12
            -- if client:supports_method("textDocument/documentColor") then
            --     vim.lsp.document_color.enable(true, args.buf, {
            --         style = "background",
            --     })
            -- end

            for _, km in ipairs(default_mappings) do
                if not km.has or client.server_capabilities[km.has] then
                    vim.keymap.set(
                        km.mode or "n",
                        km.keys,
                        km.func,
                        { buffer = buf, desc = "LSP: " .. km.desc, nowait = km.nowait }
                    )
                end
            end
        end
    end,
})

vim.diagnostic.config({
    virtual_text = {
        prefix = "",
        format = function(diagnostic)
            local win = vim.api.nvim_get_current_win()
            local cfg = vim.api.nvim_win_get_config(win)

            if cfg.relative ~= "" then
                return diagnostic.message
            end

            return "◾"
        end,
    },
    float = {
        border = "single",
        header = "",
        severity_sort = true,
        source = "if_many",
    },
    underline = false,
    severity_sort = true,
    signs = false,
    -- signs = {
    --     text = {
    --         [vim.diagnostic.severity.ERROR] = lsputils.icons.diagnostic.error,
    --         [vim.diagnostic.severity.WARN] = lsputils.icons.diagnostic.warn,
    --         [vim.diagnostic.severity.HINT] = lsputils.icons.diagnostic.hint,
    --         [vim.diagnostic.severity.INFO] = lsputils.icons.diagnostic.info,
    --     }
    -- }
})

vim.lsp.enable({
    "lua_ls",
    "pylsp",
    "ruff",
    "marksman",
    "bashls",
    "yamlls",
    "jsonls",
})
