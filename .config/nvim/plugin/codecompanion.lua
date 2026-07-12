vim.pack.add({
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/olimorris/codecompanion.nvim" },
}, { confirm = false })

require("codecompanion").setup({
    opts = { log_level = "DEBUG" },
    display = { diff = { enabled = false } },
    adapters = {
        http = {
            opts = {
                -- Only display the two custom DeepSeek adapters.
                show_presets = false,
                -- Each adapter already has its own default model.
                show_model_choices = true,
            },
            -- DeepSeek Flash:
            -- Thinking disabled.
            deepseek_flash = function()
                return require("codecompanion.adapters").extend("deepseek", {
                    name = "deepseek_flash",
                    formatted_name = "DeepSeek V4 Flash - Writing",
                    env = { api_key = "DEEPSEEK_API_KEY" },
                    schema = {
                        model = { default = "deepseek-v4-flash" },
                        ["thinking.type"] = { default = "disabled" },
                        temperature = { default = 0.6 },
                        top_p = { default = 1.0 },
                        max_tokens = { default = 8192 },
                    },
                })
            end,
            -- DeepSeek Pro:
            -- Thinking enabled.
            deepseek_pro = function()
                return require("codecompanion.adapters").extend("deepseek", {
                    name = "deepseek_pro",
                    formatted_name = "DeepSeek V4 Pro - Coding",
                    env = { api_key = "DEEPSEEK_API_KEY" },
                    schema = {
                        model = { default = "deepseek-v4-pro" },
                        ["thinking.type"] = { default = "enabled" },
                        reasoning_effort = { default = "max" },
                        max_tokens = { default = 8192 },
                    },
                })
            end,
        },
    },
    interactions = {
        -- Used by prompt-library items and chats that do not
        -- explicitly specify an adapter.
        chat = {
            adapter = "deepseek_flash",
            opts = {
                completion_provider = "blink",
            },
        },
        -- Use Pro with thinking for inline code editing.
        inline = {
            adapter = "deepseek_pro",
        },
    },
    prompt_library = {
        ["Write New Story"] = require("prompt.writer"),
        ["Generate Commit"] = require("prompt.commit"),
    },
})

-- Keymaps
local map = vim.keymap.set

-- Open a new story-writing chat:
-- DeepSeek V4 Flash with thinking disabled.
map({ "n", "v" }, "<leader>as", function()
    vim.cmd("CodeCompanionChat adapter=deepseek_flash")
end, {
    desc = "AI: story chat",
    silent = true,
})

-- Open a new coding chat:
-- DeepSeek V4 Pro with maximum thinking.
map({ "n", "v" }, "<leader>ac", function()
    vim.cmd("CodeCompanionChat adapter=deepseek_pro")
end, {
    desc = "AI: coding chat",
    silent = true,
})

-- Toggle chat.
map({ "n", "v" }, "<leader>at", "<cmd>CodeCompanionChat Toggle<cr>", {
    desc = "AI: toggle chat",
    silent = true,
})

-- Open the prompt/action palette.
map("n", "<leader>aa", "<cmd>CodeCompanionActions<cr>", {
    desc = "AI: choose an action",
    silent = true,
})
