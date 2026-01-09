return {
    cmd = { "bash-language-server", "start" },
    settings = {
        bashIde = {
            globPattern = vim.env.GLOB_PATTERN or "*@(.sh|.inc|.bash|.command)",
        },
    },
    filetypes = { "bash", "sh", "zsh" },
    root_markers = { ".git" },
}

-- Last Modified: Tue, 30 Dec 2025 12:32:03 PM
