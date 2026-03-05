local M = {}

-- Show LSP root directory for active clients
function M.show_root_dir()
    local clients = vim.lsp.get_clients()

    if #clients == 0 then
        vim.notify("No active LSP clients found", vim.log.levels.WARN)
        return
    end
    local info = { "Active LSP Roots:" }
    for _, client in ipairs(clients) do
        local root = client.config.root_dir or "Single File Mode (nil)"
        table.insert(info, string.format("[%s]: %s", client.name, root))
    end
    print(table.concat(info, "\n"))
end

-- Toggle Autoformat for Conform
function M.toggle_autoformat()
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    print("Autoformat: " .. (vim.g.disable_autoformat and "OFF" or "ON"))
end

-- Toggle CodeLens
function M.toggle_codelens()
    local bufnr = 0
    local lenses = vim.lsp.codelens.get(bufnr)
    local is_enabled = lenses ~= nil and #lenses > 0

    if is_enabled then
        vim.lsp.codelens.clear(nil, bufnr)
        print("CodeLens: OFF")
    else
        vim.lsp.codelens.refresh({ bufnr = bufnr })
        print("CodeLens: ON")
    end
end

-- Toggle Inlay Hints
function M.toggle_inlay_hints()
    local bufnr = 0
    local is_enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })

    vim.lsp.inlay_hint.enable(not is_enabled, { bufnr = bufnr })
    print("Inlay Hints: " .. (is_enabled and "OFF" or "ON"))
end

--]]
-- LSP Symbol rename
function M.rename()
    vim.lsp.buf.rename()
end

-- Diagnostic navigation
function M.diag_next()
    vim.diagnostic.jump({ count = 1, float = true })
end

function M.diag_prev()
    vim.diagnostic.jump({ count = -1, float = true })
end

return M
