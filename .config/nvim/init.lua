vim.loader.enable()
vim.cmd.colorscheme("onedark")

local function secure(module)
    local success, err_msg = pcall(require, module)
    if not success then
        local msg = ("Error loading %s\n%s"):format(module, err_msg)
        vim.defer_fn(function()
            vim.notify(msg, vim.log.levels.ERROR)
        end, 1000)
    end
end

secure("core.options")
secure("core.autocmds")
secure("core.keymaps")
secure("core.statusline")
secure("core.winbar")
secure("core.lsp")
secure("core.lazy")
