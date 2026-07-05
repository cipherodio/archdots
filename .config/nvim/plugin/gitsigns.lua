vim.pack.add({
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
}, { confirm = false })

require("gitsigns").setup({
    attach_to_untracked = true,
    numhl = false,
    current_line_blame = false,
    signs = {
        add = { text = "▕" },
        change = { text = "▕" },
        delete = { text = "▕" },
        topdelete = { text = "▕" },
        changedelete = { text = "▕" },
        untracked = { text = "▕" },
    },
    worktrees = {
        {
            toplevel = vim.env.HOME,
            gitdir = vim.env.HOME .. "/.config/.dots",
        },
    },
})

-- Keymaps
local map = vim.keymap.set

map("n", "]c", function()
    if vim.wo.diff then
        return "]c"
    end
    vim.schedule(function()
        ---@diagnostic disable-next-line: missing-fields
        require("gitsigns").nav_hunk("next", { wrap = false })
    end)
    return "<Ignore>"
end, { desc = "GS: next hunk", silent = true, expr = true })

map("n", "[c", function()
    if vim.wo.diff then
        return "[c"
    end
    vim.schedule(function()
        ---@diagnostic disable-next-line: missing-fields
        require("gitsigns").nav_hunk("prev", { wrap = false })
    end)
    return "<Ignore>"
end, { desc = "GS: previous hunk", silent = true, expr = true })

map("n", "<leader>gp", require("gitsigns").preview_hunk_inline, {
    desc = "GS: preview hunk",
    silent = true,
})

map("n", "<leader>gl", require("gitsigns").toggle_current_line_blame, {
    desc = "GS: toggle line blame",
    silent = true,
})

map({ "n", "v" }, "<leader>gr", function()
    local m = vim.api.nvim_get_mode().mode
    if m:lower() == "v" then
        require("gitsigns").reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    else
        require("gitsigns").reset_hunk()
    end
end, { desc = "GS: reset hunk", silent = true })

map({ "n", "v" }, "<leader>gs", function()
    local m = vim.api.nvim_get_mode().mode
    if m:lower() == "v" then
        require("gitsigns").stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    else
        require("gitsigns").stage_hunk()
    end
end, { desc = "GS: stage and unstage hunk", silent = true })
