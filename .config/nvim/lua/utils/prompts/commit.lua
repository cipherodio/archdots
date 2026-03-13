return {
    strategy = "inline", -- Using 'chat' is often better for reviewing the message before applying
    description = "Generate Commit",
    opts = {
        index = 10,
        is_default = true,
        is_slash_cmd = true,
        short_name = "commit",
        auto_submit = true,
        user_prompt = false,
        placement = "replace",
        adapter = {
            opts = { show_diff = false },
        },
    },
    prompts = {
        {
            role = "system",
            content = [[You are an expert at writing Conventional Commits.
      Guidelines:
      1. Use the format: <type>(<scope>): <subject>
      2. Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert.
      3. Use the imperative, present tense: "change" not "changed" nor "changes".
      4. Don't capitalize the first letter.
      5. No dot (.) at the end.]],
        },
        {
            role = "user",
            content = function()
                local diff = vim.fn.system("git diff --staged")
                if diff == "" then
                    return "I have no staged changes. Please tell the user to stage some files first."
                end
                return "Write a conventional commit message for these staged changes:\n\n```diff\n"
                    .. diff
                    .. "\n```"
            end,
        },
    },
}
