local M = {}

-- Core mapping logic (policy lives here)
function M.map(mode, lhs, rhs, opts)
    local options = {
        noremap = true,
        silent = true,
    }

    if opts then
        options = vim.tbl_extend("force", options, opts)
    end

    vim.keymap.set(mode, lhs, rhs, options)
end

-- Convenience wrappers (no logic duplication)
function M.nmap(lhs, rhs, opts)
    M.map("n", lhs, rhs, opts)
end

function M.imap(lhs, rhs, opts)
    M.map("i", lhs, rhs, opts)
end

function M.vmap(lhs, rhs, opts)
    M.map("v", lhs, rhs, opts)
end

function M.xmap(lhs, rhs, opts)
    M.map("x", lhs, rhs, opts)
end

function M.omap(lhs, rhs, opts)
    M.map("o", lhs, rhs, opts)
end

return M
