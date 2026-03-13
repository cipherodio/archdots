return {
    "olimorris/codecompanion.nvim",
    cmd = {
        "CodeCompanion",
        "CodeCompanionChat",
        "CodeCompanionActions",
        "CodeCompanionCmd",
        "CodeCompanionHistory",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    keys = {
        {
            "<leader>ac",
            "<cmd>CodeCompanionChat Toggle<cr>",
            desc = "AI: chat",
            mode = { "n", "v" },
        },
        {
            "<leader>aa",
            "<cmd>CodeCompanionAction<cr>",
            desc = "AI: choose an action",
            mode = "n",
        },
    },
    opts = {
        opts = { log_level = "DEBUG" },
        adapters = {
            http = {
                deepseek = function()
                    return require("codecompanion.adapters").extend("deepseek", {
                        env = { api_key = "DEEPSEEK_API_KEY" },
                        schema = {
                            model = {
                                -- DeepseekV3
                                default = "deepseek-chat",
                                -- DeepseekR1
                                -- default = "deepseek-reasoner",
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
                                            can_reason = false,
                                            can_use_tools = false,
                                        },
                                    },
                                },
                            },
                            -- DeepseekV3
                            max_tokens = { default = 8192 },
                            temperature = { default = 1.0 },
                            top_p = { default = 1.0 },
                            frequency_penalty = { default = 0 },
                            presence_penalty = { default = 0 },
                            -- DeepseekR1
                            -- max_tokens = { default = 4096 },
                            -- temperature = { default = 0.7 },
                            -- top_p = { default = 0.9 },
                            -- frequency_penalty = { default = 0.1 },
                            -- presence_penalty = { default = 0.1 },
                        },
                    })
                end,
            },
        },
        strategies = {
            chat = {
                adapter = "deepseek",
                model = "deepseek-chat",
                -- model = "deepseek-reasoner",
            },
            inline = {
                adapter = "deepseek",
                model = "deepseek-chat",
                -- model = "deepseek-reasoner",
            },
        },
        prompt_library = {
            ["New Story"] = require("utils.prompts.new_story"),
            ["Generate Commit"] = require("utils.prompts.commit"),
        },
    },
}
