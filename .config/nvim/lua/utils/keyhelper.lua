local M = {}

-- Core mapping policy logic
function M.map(mode, lhs, rhs, opts)
    local options = {
        silent = true,
    }

    if opts then
        options = vim.tbl_extend("force", options, opts)
    end

    vim.keymap.set(mode, lhs, rhs, options)
end

-- Convenience wrappers
function M.nmap(lhs, rhs, opts)
    M.map("n", lhs, rhs, opts)
end

function M.rmap(lhs, rhs, opts)
    local r_opts = vim.tbl_extend("force", opts or {}, { remap = true })
    M.map("n", lhs, rhs, r_opts)
end

function M.emap(lhs, rhs, opts)
    local e_opts = vim.tbl_extend("force", opts or {}, { expr = true })
    M.map("n", lhs, rhs, e_opts)
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

function M.nvmap(lhs, rhs, opts)
    M.map({ "n", "v" }, lhs, rhs, opts)
end

return M
