local M = {}

local function normalize(opts)
    return vim.tbl_extend("force", {
        silent = true,
    }, opts or {})
end

setmetatable(M, {
    __call = function(_, mode, lhs, rhs, opts)
        vim.keymap.set(mode, lhs, rhs, normalize(opts))
    end,
})

function M.e(mode, lhs, rhs, opts)
    opts = normalize(opts)
    opts.expr = true

    vim.keymap.set(mode, lhs, rhs, opts)
end

function M.r(mode, lhs, rhs, opts)
    opts = normalize(opts)
    opts.remap = true

    vim.keymap.set(mode, lhs, rhs, opts)
end

return M
