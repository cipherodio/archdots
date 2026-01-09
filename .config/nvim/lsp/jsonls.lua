return {
    cmd = { 'vscode-json-language-server', '--stdio' },
    filetypes = { 'json', 'jsonc' },
    init_options = {
        provideFormatter = true,
    },
    root_markers = { '.git' },
    settings = {
        json = { format = { enable = true } },
    },
}

-- Last Modified: Tue, 30 Dec 2025 12:46:45 PM
