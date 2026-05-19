vim.pack.add({
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
}, { confirm = false })

local g = require("gitsigns")
local k = require("utils.keyhelper")

g.setup({
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
k("n", "]c", function()
    if vim.wo.diff then
        return "]c"
    end
    vim.schedule(function()
        g.nav_hunk("next", { wrap = false })
    end)
    return "<Ignore>"
end, { expr = true, desc = "GS: next hunk" })

k("n", "[c", function()
    if vim.wo.diff then
        return "[c"
    end
    vim.schedule(function()
        g.nav_hunk("prev", { wrap = false })
    end)
    return "<Ignore>"
end, { expr = true, desc = "GS: previous hunk" })

k("n", "<leader>gp", g.preview_hunk_inline, { desc = "GS: preview hunk" })
k("n", "<leader>gl", g.toggle_current_line_blame, { desc = "GS: toggle line blame" })

k({ "n", "v" }, "<leader>gr", function()
    local m = vim.api.nvim_get_mode().mode
    if m:lower() == "v" then
        g.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    else
        g.reset_hunk()
    end
end, { desc = "GS: reset hunk" })

k({ "n", "v" }, "<leader>gS", function()
    local m = vim.api.nvim_get_mode().mode
    if m:lower() == "v" then
        g.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    else
        g.stage_hunk()
    end
end, { desc = "GS: stage hunk" })
