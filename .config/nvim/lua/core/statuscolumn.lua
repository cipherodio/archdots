local Status = {}

function Status.LspDiagnostics(bufnr, lnum)
    local diag_icon = " "
    local hl_group = "DiagnosticSignInfo"
    local config = vim.diagnostic.config()

    if config and config.signs == false then
        return "  "
    end

    local diags = vim.diagnostic.get(bufnr, { lnum = lnum })
    if #diags > 0 then
        table.sort(diags, function(a, b)
            return a.severity < b.severity
        end)
        local severity = diags[1].severity
        local icon_map = {
            [vim.diagnostic.severity.ERROR] = "E",
            [vim.diagnostic.severity.WARN] = "W",
            [vim.diagnostic.severity.INFO] = "I",
            [vim.diagnostic.severity.HINT] = "H",
        }
        local hl_map = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
            [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
            [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
        }
        diag_icon = icon_map[severity] or " "
        hl_group = hl_map[severity] or "DiagnosticSignInfo"
    end
    return "%#" .. hl_group .. "#" .. diag_icon .. "%* "
end

function Status.TodoSign(bufnr, lnum)
    local todo_icon = " "
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
        if marks and marks[1] and marks[1][4] and marks[1][4].sign_text then
            todo_icon = vim.trim(marks[1][4].sign_text)
            hl_group = marks[1][4].sign_hl_group or marks[1][4].hl_group or "Todo"
        end
    end
    return "%#" .. hl_group .. "#" .. todo_icon .. "%* "
end

function Status.GitSign(bufnr, lnum)
    local git_icon = " "
    local git_ns = vim.api.nvim_get_namespaces()["gitsigns_signs_"]

    if git_ns then
        local marks = vim.api.nvim_buf_get_extmarks(
            bufnr,
            git_ns,
            { lnum, 0 },
            { lnum, -1 },
            { details = true }
        )
        if marks and marks[1] and marks[1][4] and marks[1][4].sign_text then
            git_icon = vim.trim(marks[1][4].sign_text)
        end
    end
    return "%#GitSignsAdd#" .. git_icon .. "%* "
end

function Status.LineNumber()
    return "%=%l "
end

_G.MyStatusColumn = function()
    local winid = vim.g["statusline_winid"] or 0
    local bufnr = vim.api.nvim_win_get_buf(winid)

    if vim.v.virtnum ~= 0 then
        return ""
    end
    local lnum = vim.v.lnum - 1
    return table.concat({
        Status.LspDiagnostics(bufnr, lnum),
        Status.TodoSign(bufnr, lnum),
        Status.GitSign(bufnr, lnum),
        Status.LineNumber(),
    })
end

vim.opt.statuscolumn = "%!v:lua.MyStatusColumn()"

local group = vim.api.nvim_create_augroup("StatusColumnRefresh", { clear = true })

vim.api.nvim_create_autocmd("DiagnosticChanged", {
    desc = "Refresh LSP diagnostic signs",
    group = group,
    callback = function()
        local stc = vim.api.nvim_get_option_value("statuscolumn", {
            scope = "global",
        })
        vim.api.nvim_set_option_value("statuscolumn", stc, {
            scope = "global",
        })
    end,
})
