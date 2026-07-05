vim.pack.add({
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/olimorris/codecompanion.nvim" },
}, { confirm = false })

require("codecompanion").setup({
    opts = { log_level = "DEBUG" },
    adapters = {
        http = {
            deepseek = function()
                return require("codecompanion.adapters").extend("openai", {
                    name = "deepseek",
                    url = "https://api.deepseek.com/v1/chat/completions",
                    env = { api_key = "DEEPSEEK_API_KEY" },
                    schema = {
                        model = {
                            default = "deepseek-v4-flash",
                            choices = {
                                ["deepseek-v4-flash"] = {
                                    formatted_name = "DeepSeek v4 Flash",
                                    opts = {
                                        can_reason = false,
                                        can_use_tools = true,
                                    },
                                },
                                ["deepseek-v4-pro"] = {
                                    formatted_name = "DeepSeek V4 Pro",
                                    opts = {
                                        can_reason = true,
                                        can_use_tools = false,
                                    },
                                },
                            },
                        },
                        max_tokens = { default = 8192 },
                        temperature = { default = 1.2 },
                        top_p = { default = 0.95 },
                        frequency_penalty = { default = 0.4 },
                        presence_penalty = { default = 0.4 },
                    },
                })
            end,
        },
    },
    strategies = {
        chat = {
            adapter = "deepseek",
            -- model = "deepseek-v4-flash",
        },
        inline = {
            adapter = "deepseek",
            -- model = "deepseek-v4-flash",
        },
    },
    prompt_library = {
        ["Write New Story"] = require("prompt.writer"),
        ["Generate Commit"] = require("prompt.commit"),
    },
})

-- Keymaps
local map = vim.keymap.set

map({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", {
    desc = "AI: chat",
    silent = true,
})

map("n", "<leader>aa", "<cmd>CodeCompanionAction<cr>", {
    desc = "AI: choose an action",
    silent = true,
})
