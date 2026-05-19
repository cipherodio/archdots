-- Experimental loader
vim.loader.enable()

-- Experimental UI2
require("vim._core.ui2").enable({
    msg = {
        targets = { echomsg = "msg" },
        msg = {
            height = 0.3,
            timeout = 5000,
        },
    },
})

-- Colorscheme
vim.cmd.colorscheme("gruvbox")

-- Use pcall to load modules
---@param module string
local function spec(module)
    local success, err_msg = pcall(require, module)
    if not success then
        local msg = ("Error loading %s\n%s"):format(module, err_msg)
        vim.defer_fn(function()
            vim.notify(msg, vim.log.levels.ERROR)
        end, 1000)
    end
end

spec("core.options")
spec("core.autocmds")
spec("core.keymaps")
spec("core.lsp")
spec("core.statusline")
spec("core.winbar")
