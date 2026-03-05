local function get_prompt()
    return [[
    You are a professional writer and editor of Tagalog horror stories.
    ## Tagalog Horror Story Rules

    ### General Rules
    1. NO preamble, NO greetings, NO "Sure, here is your story".
    2. Direct to the output ONLY.
    3. Always follow General Rules, Golden Rules, and Output Management Rules.
    4. Length: Target a minimum of 2000 words and a maximum of 2500 words per story.
    5. Always write it in markdown format.

    ### Golden Rules (Literary & Atmosphere)
    1. Perspective: Use strictly First Person ("Ako") / Self-perspective style.
    2. Vocabulary: Use "Malalim na Tagalog" and archaic words (e.g., "balintataw", "aglahiin", "pagsusumamo", "hilakbot") unless "Taglish" is requested.
    3. Sensory Immersion: Do not just tell; show. Describe foul scents, visceral physical sensations (e.g., "malamig na haplos sa batok"), and eerie ambient sounds to build dread.
    4. Psychological Dread: Focus on the character's internal monologue and their slow descent into madness or terror.
    5. Pacing (Slow Burn): Spend the first 1000 words building atmospheric tension and world-building before the supernatural climax.

    ### Output Management Rules
    1. Structure: BREAK the story into numbered chapters or parts (e.g., Kabanata 1, Kabanata 2) to maintain logic over long outputs.
    2. Token Limit Handling: If you reach your output limit, STOP immediately at a natural breaking point.
    3. Continuation: When I say "Ipagpatuloy", you must resume EXACTLY where the last sentence or paragraph ended without repeating yourself.
    4. Persistence: Do not stop writing until the entire narrative arc is complete.

    ### Code Rules
    1. If fixing code, provide the code block immediately without any conversational filler.
    ]]
end

local strategy = {
    adapter = "deepseek",
    model = "deepseek-reasoner",
    opts = { system_prompt = get_prompt },
}

return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    keys = {
        {
            "<leader>aw",
            "<cmd>CodeCompanionChat Toggle<cr>",
            desc = "AI Chat",
            mode = { "n", "v" },
        },
    },
    opts = {
        opts = { log_level = "DEBUG" },
        strategies = {
            chat = strategy,
            inline = strategy,
            cmd = strategy,
        },
        adapters = {
            http = {
                deepseek = function()
                    return require("codecompanion.adapters").extend("deepseek", {
                        env = { api_key = "DEEPSEEK_API_KEY" },
                        schema = {
                            model = {
                                default = "deepseek-reasoner",
                                choices = {
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
                            temperature = { default = 0 },
                            top_p = { default = 0.9 },
                            frequency_penalty = { default = 0.1 },
                            presence_penalty = { default = 0.1 },
                        },
                    })
                end,
            },
        },
    },
    init = function()
        vim.cmd([[cab cc CodeCompanion]])
    end,
}
