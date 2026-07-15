local default_configuration = vim.lsp.handlers["workspace/configuration"]
local gtk_dirs = {
    vim.fs.normalize(vim.fn.expand("~/.config/gtk-3.0")),
    vim.fs.normalize(vim.fn.expand("~/.config/gtk-4.0")),
}

local function is_gtk_css(filename)
    filename = vim.fs.normalize(filename)

    for _, gtk_dir in ipairs(gtk_dirs) do
        if vim.startswith(filename, gtk_dir .. "/") then
            return true
        end
    end

    return false
end

---@type vim.lsp.Config
return {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = { "css", "scss", "less" },
    init_options = { provideFormatter = true },
    root_markers = { "package.json", ".git" },
    workspace_required = false,
    settings = {
        css = { validate = true },
        scss = { validate = true },
        less = { validate = true },
    },
    handlers = {
        ["workspace/configuration"] = function(err, params, ctx)
            local response = default_configuration(err, params, ctx)

            if not response then
                return
            end

            for index, item in ipairs(params.items or {}) do
                if item.section == "css" and item.scopeUri then
                    local filename = vim.uri_to_fname(item.scopeUri)

                    if is_gtk_css(filename) then
                        local settings = type(response[index]) == "table"
                                and response[index]
                            or {}

                        response[index] = vim.tbl_extend(
                            "force",
                            {},
                            settings,
                            { validate = false }
                        )
                    end
                end
            end

            return response
        end,
    },
}
