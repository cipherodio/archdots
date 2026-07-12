vim.loader.enable()

require("vim._core.ui2").enable({
    msg = { targets = { echomsg = "msg" } },
})

---@param module string
local function spec(module)
    local ok, err_msg = pcall(require, module)
    if not ok then
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
