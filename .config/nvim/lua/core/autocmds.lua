local autocmd = vim.api.nvim_create_autocmd

local h = require("utils.helper")
local k = require("utils.keyhelper")
local m = require("utils.mdhelper")

---@param name string
---@return integer
local function augroup(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Augroups
local groups = {
    relnumbers = augroup("relnumbers"),
    whitespaces = augroup("whitespaces"),
    yankhighlight = augroup("yankhighlight"),
    nocomment_o = augroup("nocomment_o"),
    cursor_pos = augroup("cursor_pos"),
    closewith_q = augroup("closewith_q"),
    create_dir = augroup("create_dir"),
    reload_shortcuts = augroup("reload_shortcuts"),
    reload_xdefaults = augroup("reload_xdefaults"),
    reload_dunst = augroup("reload_dunst"),
    markdown_gf = augroup("markdown_gf"),
}

-- Relative numbers
autocmd({ "BufEnter", "WinEnter", "InsertLeave", "CmdlineLeave" }, {
    desc = "Enable relative number",
    group = groups.relnumbers,
    callback = function()
        if vim.wo.number and vim.api.nvim_get_mode().mode ~= "i" then
            vim.wo.relativenumber = true
        end
    end,
})

autocmd({ "BufLeave", "WinLeave", "InsertEnter", "CmdlineEnter" }, {
    desc = "Disable relative number",
    group = groups.relnumbers,
    callback = function()
        if vim.wo.number then
            vim.wo.relativenumber = false
        end
    end,
})

-- Cleanup whitespace
autocmd("BufWritePre", {
    desc = "Remove trailing white spaces and convert tabs to spaces",
    group = groups.whitespaces,
    callback = function()
        if not vim.bo.modifiable then
            return
        end
        local view = vim.fn.winsaveview()
        pcall(function()
            vim.cmd("undojoin")
        end)
        vim.cmd([[silent! keepjumps keepmarks %s/\s\+$//e]])
        vim.cmd([[silent! keepjumps keepmarks retab!]])
        vim.fn.winrestview(view)
    end,
})

-- Yank highlight
autocmd("TextYankPost", {
    desc = "Highlight text on yank",
    group = groups.yankhighlight,
    callback = function()
        vim.hl.on_yank({
            higroup = "IncSearch",
            timeout = 700,
        })
    end,
})

-- Disable comment continuation
autocmd("BufWinEnter", {
    desc = "Never insert comment when using 'o' to enter insert mode",
    group = groups.nocomment_o,
    callback = function()
        vim.opt.formatoptions:remove({ "o" })
    end,
})

-- Restore cursor position
autocmd("BufReadPost", {
    desc = "Restore last cursor position",
    group = groups.cursor_pos,
    callback = h.restore_cursor,
})

-- Close windows with q
autocmd("FileType", {
    desc = "Close temporary buffers with q",
    group = groups.closewith_q,
    pattern = {
        "help",
        "checkhealth",
        "qf",
        "query",
        "man",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        k("n", "q", h.smart_quit, {
            buffer = event.buf,
            desc = "Smart quit",
        })
    end,
})

-- Auto-create missing directories
autocmd("BufWritePre", {
    desc = "Auto-create missing directories on save",
    group = groups.create_dir,
    callback = function(event)
        if event.match:match("^%w%w+://") then
            return
        end
        local file = vim.fn.expand("<afile>:p")
        local dir = vim.fn.fnamemodify(file, ":p:h")
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, "p")
        end
    end,
})

-- Reload shortcuts
autocmd("BufWritePost", {
    desc = "Reload shortcuts after config update",
    group = groups.reload_shortcuts,
    pattern = { "bm-files", "bm-dirs" },
    callback = function()
        vim.system({ "shortcuts" }, { detach = true })
    end,
})

-- Reload Xresources
autocmd("BufWritePost", {
    desc = "Reload Xresources after config update",
    group = groups.reload_xdefaults,
    pattern = { "xdefaults" },
    callback = function(args)
        vim.system({ "xrdb", args.file }, { detach = true })
    end,
})

-- Reload dunst
autocmd("BufWritePost", {
    desc = "Reload dunst after config update",
    group = groups.reload_dunst,
    pattern = { "dunstrc" },
    callback = function()
        vim.system({ "pkill", "dunst" })
        vim.system({ "dunst" }, { detach = true })
    end,
})

-- Markdown follow link
autocmd("FileType", {
    desc = "Follow markdown links with gf",
    group = groups.markdown_gf,
    pattern = "markdown",
    callback = function(event)
        k("n", "gf", m.follow_markdown_link, {
            buffer = event.buf,
            desc = "Follow markdown link",
        })
    end,
})
