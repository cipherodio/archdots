---@type vim.lsp.Config
return {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = {
        ".git",
        ".luarc.json",
        ".stylua.toml",
        "stylua.toml",
    },
    log_level = 0,
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            telemetry = { enable = false },
            workspace = {
                checkThirdParty = false,
            },
            doc = { privateName = { "^_" } },
            codeLens = { enable = true },
            hint = {
                enable = true,
                semicolon = "Disable",
                arrayIndex = "Disable",
            },
        },
    },
}
