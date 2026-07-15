local autocmd = vim.api.nvim_create_autocmd
local map = vim.keymap.set
---@param name string
---@return integer
local function augroup(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end

-- Relative numbers
autocmd({ "BufEnter", "WinEnter", "InsertLeave", "CmdlineLeave" }, {
    desc = "Enable relative number",
    group = augroup("relnum_on"),
    callback = function()
        if vim.wo.number and vim.api.nvim_get_mode().mode ~= "i" then
            vim.wo.relativenumber = true
        end
    end,
})

autocmd({ "BufLeave", "WinLeave", "InsertEnter", "CmdlineEnter" }, {
    desc = "Disable relative number",
    group = augroup("relnum_off"),
    callback = function()
        if vim.wo.number then
            vim.wo.relativenumber = false
        end
    end,
})

-- Cleanup whitespace
autocmd("BufWritePre", {
    desc = "Remove trailing white spaces and convert tabs to spaces",
    group = augroup("whitespaces"),
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
    group = augroup("yankhighlight"),
    callback = function()
        vim.hl.on_yank({
            higroup = "IncSearch",
            timeout = 700,
        })
    end,
})

-- Disable comment continuation with letter o
autocmd("BufWinEnter", {
    desc = "Never insert comment when using 'o' to enter insert mode",
    group = augroup("nocomment_o"),
    callback = function()
        vim.opt.formatoptions:remove({ "o" })
    end,
})

-- Restore cursor position
autocmd("BufReadPost", {
    desc = "Restore last cursor position",
    group = augroup("cursor_pos"),
    callback = require("fn.util").restore_cursor,
})

-- Close windows with q
autocmd("FileType", {
    desc = "Close temporary buffers with q",
    group = augroup("closewith_q"),
    pattern = {
        "help",
        "checkhealth",
        "qf",
        "query",
        "man",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        map("n", "q", require("fn.util").smart_quit, {
            buffer = event.buf,
            desc = "Smart quit",
            silent = true,
        })
    end,
})

-- Auto-create missing directories
autocmd("BufWritePre", {
    desc = "Auto-create missing directories on save",
    group = augroup("create_dir"),
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
    group = augroup("reload_shortcuts"),
    pattern = { "bm-files", "bm-dirs" },
    callback = function()
        vim.system({ "shortcuts" }, { detach = true })
    end,
})

-- Reload Xresources
autocmd("BufWritePost", {
    desc = "Reload Xresources after config update",
    group = augroup("reload_xdefaults"),
    pattern = "xdefaults",
    callback = function()
        local result = vim.system({ "theme", "reload" }, { text = true }):wait()

        if result.code ~= 0 then
            vim.notify(
                vim.trim(result.stderr or "Failed to reload Xresources"),
                vim.log.levels.ERROR
            )
        end
    end,
})

-- Reload dunst
autocmd("BufWritePost", {
    desc = "Reload dunst after config update",
    group = augroup("reload_dunst"),
    pattern = { "dunstrc" },
    callback = function()
        vim.system({ "pkill", "dunst" })
        vim.system({ "dunst" }, { detach = true })
    end,
})

-- Markdown follow link
autocmd("FileType", {
    desc = "Follow markdown links with gf",
    group = augroup("mardown_gf"),
    pattern = "markdown",
    callback = function(event)
        map("n", "gf", require("fn.markdown").follow_markdown_link, {
            buffer = event.buf,
            desc = "Follow markdown link",
            silent = true,
        })
    end,
})
