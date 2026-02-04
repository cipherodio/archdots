local ui = require("utils.colors")

-- Highlight definitions
local highlights = {
    WinBarModified = { fg = ui.c02, bg = ui.c01, bold = true },
    ModifiedTextMain = { fg = ui.c05, bg = ui.c11, bold = true },
    BufferColor = { fg = ui.c03, bg = ui.c01, bold = true },
}

local function apply_highlights()
    for group, opts in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, opts)
    end
end

apply_highlights()

vim.api.nvim_create_autocmd("ColorScheme", {
    callback = apply_highlights,
})

-- Helpers
local function spacer(n)
    return "%#ModifiedTextMain#" .. string.rep(" ", n)
end

local function align()
    return "%="
end

local excluded_filetypes = {
    help = true,
    dashboard = true,
    lazy = true,
    neogitstatus = true,
    NvimTree = true,
    Trouble = true,
    toggleterm = true,
}

-- Winbar components
local function buffer_number()
    local bufnr = vim.api.nvim_get_current_buf()
    return "%#BufferColor#[" .. bufnr .. "]" .. spacer(1)
end

local function file_path()
    local name = vim.api.nvim_buf_get_name(0)
    if name == "" then
        return ""
    end

    -- Use ~ for home, then replace leading ~ with $HOME
    name = vim.fn.fnamemodify(name, ":~")
    name = name:gsub("^~", "$HOME")

    -- Pretty separators
    name = name:gsub("/", " ")

    return "%#ModifiedTextMain#" .. name
end

local function search_match()
    if vim.v.hlsearch == 0 then
        return ""
    end

    local pat = vim.fn.getreg("/")
    if pat == "" then
        return ""
    end

    local ok, sc = pcall(vim.fn.searchcount, { maxcount = 9999 })
    if not ok or sc.total == 0 then
        return ""
    end

    return pat .. "[" .. sc.current .. "/" .. sc.total .. "]"
end

-- Winbar renderer
_G.WinBars = function()
    if excluded_filetypes[vim.bo.filetype] then
        return ""
    end

    return table.concat({
        buffer_number(),
        file_path(),
        align(),
        search_match(),
    })
end

-- Autocommands
vim.api.nvim_create_augroup("WinBars", { clear = true })

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
    group = "WinBars",
    callback = function(args)
        local win = 0

        if
            not vim.api.nvim_win_get_config(win).zindex
            and vim.bo[args.buf].buftype == ""
            and vim.api.nvim_buf_get_name(args.buf) ~= ""
            and not vim.wo[win].diff
        then
            vim.wo[win].winbar = "%{%v:lua.WinBars()%}"
        end
    end,
})
