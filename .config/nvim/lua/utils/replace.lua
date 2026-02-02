local M = {}

-- Fast replace using vim.ui.input (no confirm)
function M.replace_word_fast()
    local old = vim.fn.expand("<cword>")
    if old == "" then
        return
    end

    vim.ui.input({
        prompt = "Replace with:",
        default = old,
    }, function(new)
        if not new or new == "" or new == old then
            return
        end

        vim.cmd(
            string.format(
                "%%s/\\<%s\\>/%s/gI",
                vim.pesc(old),
                vim.fn.escape(new, [[\/&]])
            )
        )
    end)
end

-- Confirm replace (gc)
function M.replace_word_confirm()
    local old = vim.fn.expand("<cword>")
    if old == "" then
        return
    end

    vim.ui.input({
        prompt = "Replace word:",
        default = old,
    }, function(new)
        if not new or new == "" or new == old then
            return
        end

        vim.cmd(
            string.format(
                "%%s/\\<%s\\>/%s/gcI",
                vim.pesc(old),
                vim.fn.escape(new, [[\/&]])
            )
        )
    end)
end

return M
