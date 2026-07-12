return {
    interaction = "inline",
    description = "Generate Commit",
    opts = {
        alias = "commit",
        is_slash_cmd = true,
        auto_submit = true,
        user_prompt = false,
        placement = "replace",
    },
    prompts = {
        {
            role = "system",
            content = [[
# You are an expert at writing Conventional Commits.

## Guidelines:
1. Use the format: <type>(<scope>): <subject>
2. Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore, revert.
3. Use the imperative, present tense: "change" not "changed" nor "changes".
4. Don't capitalize the first letter.
5. No dot (.) at the end.]],
        },
        {
            role = "user",
            content = function()
                local diff = vim.fn.system("git diff --no-ext-diff --staged")

                if vim.v.shell_error ~= 0 then
                    return "Unable to read the staged Git changes."
                end

                if diff == "" then
                    return "There are no staged changes. Tell the user to stage some files first."
                end

                return "Write a conventional commit message for these staged changes:\n\n```diff\n"
                    .. diff
                    .. "\n```"
            end,
        },
    },
}
