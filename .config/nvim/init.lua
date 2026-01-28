vim.loader.enable()
-- vim.cmd.colorscheme("gruvbox")
vim.cmd.colorscheme("onedark")
-- vim.cmd.colorscheme("gruvbox-material")

local function secured(module)
    local success, err_msg = pcall(require, module)
    if not success then
        local msg = ("Error loading %s\n%s"):format(module, err_msg)
        vim.defer_fn(function()
            vim.notify(msg, vim.log.levels.ERROR)
        end, 1000)
    end
end

secured("core.options")
secured("core.autocmds")
secured("core.keymaps")
secured("core.statusline")
secured("core.winbar")
secured("core.lsp")
secured("core.lazy")

-- Last Modified: Wed, 28 Jan 2026 05:32:59 PM
