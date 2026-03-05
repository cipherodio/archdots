local Status = {}

function Status.TodoSign(bufnr, lnum)
    local todo_icon = "  "
    local hl_group = "Todo"

    local todo_ns = vim.api.nvim_get_namespaces()["todo-signs"]
        or vim.api.nvim_get_namespaces()["todo-comments"]

    if todo_ns then
        local marks = vim.api.nvim_buf_get_extmarks(
            bufnr,
            todo_ns,
            { lnum, 0 },
            { lnum, -1 },
            { details = true }
        )

        local first_mark = marks and marks[1]
        local details = first_mark and first_mark[4]

        if details and details.sign_text then
            todo_icon = details.sign_text
            hl_group = details.sign_hl_group or details.hl_group or "Todo"
        end
    end
    return "%#" .. hl_group .. "#" .. todo_icon .. "%* "
end

function Status.GitSign(bufnr, lnum)
    local git_icon = "  "
    local git_ns = vim.api.nvim_get_namespaces()["gitsigns_signs_"]

    if git_ns then
        local marks = vim.api.nvim_buf_get_extmarks(
            bufnr,
            git_ns,
            { lnum, 0 },
            { lnum, -1 },
            { details = true }
        )
        if marks[1] and marks[1][4] and marks[1][4].sign_text then
            git_icon = marks[1][4].sign_text
        end
    end
    return "%#GitSignsAdd#" .. git_icon .. "%*"
end

function Status.LineNumber()
    return "%=%l "
end

-- Render statuscolumn
_G.MyStatusColumn = function()
    if vim.v.virtnum ~= 0 then
        return ""
    end

    local bufnr = vim.api.nvim_get_current_buf()
    local lnum = vim.v.lnum - 1

    return table.concat({
        Status.TodoSign(bufnr, lnum),
        Status.GitSign(bufnr, lnum),
        Status.LineNumber(),
    })
end

vim.opt.statuscolumn = "%!v:lua.MyStatusColumn()"
