local autocmd = vim.api.nvim_create_autocmd
local f = require("utils.followlink")
local h = require("utils.helper")

local function augroup(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end

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

autocmd({ "BufEnter", "WinEnter", "InsertLeave", "CmdlineLeave" }, {
    desc = "Enable relative number",
    group = groups.relnumbers,
    callback = function()
        if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
            vim.opt.relativenumber = true
        end
    end,
})

autocmd({ "BufLeave", "WinLeave", "InsertEnter", "CmdlineEnter" }, {
    desc = "Disable relative number",
    group = groups.relnumbers,
    callback = function()
        if vim.o.nu then
            vim.opt.relativenumber = false
        end
    end,
})

autocmd("BufWritePre", {
    desc = "Remove trailing white spaces",
    group = groups.whitespaces,
    callback = function()
        if not vim.bo.modifiable then
            return
        end
        vim.cmd([[silent! %s/\s\+$//]])
    end,
})

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

autocmd("BufWinEnter", {
    desc = "Never insert comment when using 'o' to enter insert mode",
    group = groups.nocomment_o,
    callback = function()
        vim.opt.formatoptions:remove({ "o" })
    end,
})

autocmd("BufReadPost", {
    desc = "Save cursor position on quit",
    group = groups.cursor_pos,
    callback = function()
        vim.schedule(function()
            local mark = vim.api.nvim_buf_get_mark(0, '"')
            if mark[1] > 1 then
                pcall(vim.api.nvim_win_set_cursor, 0, mark)
            end
        end)
    end,
})

autocmd("FileType", {
    desc = "Close with just letter q",
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
        vim.keymap.set("n", "q", h.smart_quit, {
            buffer = event.buf,
            silent = true,
            desc = "Smart quit",
        })
    end,
})

autocmd("BufWritePre", {
    desc = "Auto create dir if nonexistent after save",
    group = groups.create_dir,
    callback = function(event)
        if event.match:match("^%w%w+://") then
            return
        end
        local file = vim.uv.fs_realpath(event.match) or event.match
        local dir = vim.fn.fnamemodify(file, ":p:h")
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, "p")
        end
    end,
})

autocmd("BufWritePost", {
    desc = "Auto reload bin script shortcuts when configuration is updated",
    group = groups.reload_shortcuts,
    pattern = { "bm-files", "bm-dirs" },
    callback = function()
        vim.system({ "shortcuts" }, { detach = true })
    end,
})

autocmd("BufWritePost", {
    desc = "Auto reload xdefaults when configuraton is updated",
    group = groups.reload_xdefaults,
    pattern = { "xdefaults" },
    callback = function(args)
        vim.system({ "xrdb", args.file }, { detach = true })
    end,
})

autocmd("BufWritePost", {
    desc = "Auto reload dunstrc when configuration is updated",
    group = groups.reload_dunst,
    pattern = { "dunstrc" },
    callback = function()
        vim.system({ "pkill", "dunst" })
        vim.system({ "dunst" }, { detach = true })
    end,
})

autocmd("FileType", {
    desc = "Follow Markdown links",
    group = groups.markdown_gf,
    pattern = "markdown",
    callback = function()
        vim.keymap.set(
            "n",
            "gf",
            f.follow_markdown_link,
            { buffer = true, silent = true, desc = "Follow Markdown link" }
        )
    end,
})
