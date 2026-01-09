local timestamp = require("utils.timestamp")
local autocmd = vim.api.nvim_create_autocmd

local function augroup(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end

local groups = {
    whitespaces = augroup("whitespaces"),
    yankhighlight = augroup("yankhighlight"),
    nocomment_o = augroup("nocomment_o"),
    cursor_pos = augroup("cursor_pos"),
    closewith_q = augroup("closewith_q"),
    md_local_links = augroup("md_local_links"),
    modified_time = augroup("modified_time"),
    timestamp_highlight = augroup("timestamp_highlight"),
}

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

autocmd("FileType", {
    desc = "Better gf to open markdown local links",
    group = groups.md_local_links,
    pattern = "markdown",
    callback = function()
        vim.keymap.set("n", "gf", "^f/gf", { buffer = true })
    end,
})

autocmd("BufWritePre", {
    desc = "Update Last Modified timestamp",
    group = groups.modified_time,
    callback = function(args)
        if vim.bo[args.buf].buftype ~= "" then
            return
        end

        if vim.bo[args.buf].filetype == "gitcommit" then
            return
        end

        timestamp.update(args.buf)
    end,
})

autocmd({ "BufEnter", "BufWinEnter", "ColorScheme" }, {
    group = groups.timestamp_highlight,
    callback = function()
        -- Only apply to normal file buffers
        if vim.bo.buftype ~= "" then
            return
        end

        local win = vim.api.nvim_get_current_win()

        -- Clear only this window’s matches
        pcall(vim.fn.clearmatches, win)

        -- Add timestamp highlight
        vim.fn.matchadd(
            "TimestampHighlight",
            [[\v\w{3},\s\d{2}\s\w{3}\s\d{4}\s\d{2}:\d{2}:\d{2}\s(AM|PM)]],
            10
        )
    end,
})

-- Last Modified: Wed, 07 Jan 2026 01:12:55 AM
