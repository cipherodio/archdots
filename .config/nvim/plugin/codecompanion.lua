vim.pack.add({
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/olimorris/codecompanion.nvim" },
}, { confirm = false })

local c = require("codecompanion")
local ca = require("codecompanion.adapters")
local k = require("utils.keyhelper")

c.setup({
    opts = { log_level = "DEBUG" },
    adapters = {
        http = {
            deepseek = function()
                return ca.extend("deepseek", {
                    env = { api_key = "DEEPSEEK_API_KEY" },
                    schema = {
                        model = {
                            default = "deepseek-chat",
                            choices = {
                                ["deepseek-chat"] = {
                                    formatted_name = "DeepSeek Chat",
                                    opts = {
                                        can_reason = false,
                                        can_use_tools = true,
                                    },
                                },
                                ["deepseek-reasoner"] = {
                                    formatted_name = "DeepSeek Reasoner",
                                    opts = {
                                        can_reason = true,
                                        can_use_tools = false,
                                    },
                                },
                            },
                        },
                        max_tokens = { default = 8192 },
                        temperature = { default = 1.0 },
                        top_p = { default = 1.0 },
                        frequency_penalty = { default = 0 },
                        presence_penalty = { default = 0 },
                    },
                })
            end,
        },
    },
    strategies = {
        chat = {
            adapter = "deepseek",
            model = "deepseek-chat",
        },
        inline = {
            adapter = "deepseek",
            model = "deepseek-chat",
        },
    },
    prompt_library = {
        ["New Story"] = require("utils.prompts.new_story"),
        ["Generate Commit"] = require("utils.prompts.commit"),
    },
})

-- Keymaps
k({ "n", "v" }, "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", { desc = "AI: chat" })
k("n", "<leader>aa", "<cmd>CodeCompanionAction<cr>", { desc = "AI: choose an action" })
