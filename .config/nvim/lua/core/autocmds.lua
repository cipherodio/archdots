local lcd = require("utils.lcd")
local autocmd = vim.api.nvim_create_autocmd

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
    md_local_links = augroup("md_local_links"),
    reload_shortcuts = augroup("reload_shortcuts"),
    reload_xdefaults = augroup("reload_xdefaults"),
    reload_dunst = augroup("reload_dunst"),
    lcd_notes = augroup("lcd_notes"),
}

autocmd({ "BufEnter", "WinEnter", "InsertLeave", "CmdlineLeave" }, {
    desc = "Enable relative number",
    group = groups.relnumbers,
    callback = function()
        if vim.bo.buftype ~= "" then
            return
        end
        if vim.wo.number and vim.api.nvim_get_mode().mode ~= "i" then
            vim.wo.relativenumber = true
        end
    end,
})

autocmd({ "BufLeave", "WinLeave", "InsertEnter", "CmdlineEnter" }, {
    desc = "Disable relative number",
    group = groups.relnumbers,
    callback = function()
        if vim.bo.buftype ~= "" then
            return
        end
        if vim.wo.number then
            vim.wo.relativenumber = false
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
        vim.highlight.on_yank({
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
        "",
        "help",
        "lspinfo",
        "checkhealth",
        "qf",
        "query",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", vim.cmd.close, {
            buffer = event.buf,
            silent = true,
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
        local file = vim.loop.fs_realpath(event.match) or event.match
        vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    end,
})

autocmd("FileType", {
    desc = "Better gf to open markdown local links",
    group = groups.md_local_links,
    pattern = "markdown",
    callback = function()
        vim.keymap.set("n", "gf", "^f/gf", { buffer = true })
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

autocmd("BufEnter", {
    desc = "Set local cwd for notes",
    group = groups.lcd_notes,
    callback = function(args)
        lcd.maybe_lcd(args.buf)
    end,
})
