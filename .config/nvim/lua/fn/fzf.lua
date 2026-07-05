local M = {}

-- Helper for both bare and normal repository fzf keymaps
M.smart_git = function(picker_name)
    local fzf = require("fzf-lua")
    local home = vim.env.HOME
    local dot_git = home .. "/.config/.dots"
    local is_standard = vim.fn
        .system("git rev-parse --is-inside-work-tree 2>/dev/null")
        :gsub("%s+", "") == "true"
    local target_cwd, target_git_dir, target_worktree, prompt_text

    if is_standard then
        target_cwd = vim.fn.getcwd()
        target_git_dir, target_worktree, prompt_text = nil, nil, "   Project> "
    else
        target_cwd, target_git_dir, target_worktree, prompt_text =
            home, dot_git, home, "   Dotfiles> "
    end

    local function get_jackpot_list(status_cmd, all_files_cmd, cwd)
        local status_out = vim.fn.systemlist("cd " .. cwd .. " && " .. status_cmd)
        local all_tracked = all_files_cmd
                and vim.fn.systemlist("cd " .. cwd .. " && " .. all_files_cmd)
            or {}
        local results, seen = {}, {}
        local green, red, cyan, reset = "\27[32m", "\27[31m", "\27[36m", "\27[0m"

        for _, line in ipairs(status_out) do
            local file = line:sub(4):gsub("^%s+", ""):gsub('^"(.*)"$', "%1")
            if file ~= "" and not seen[file] then
                local stat = line:sub(1, 2)
                local color_stat = stat
                if stat:match("M") then
                    color_stat = green .. "M " .. reset
                elseif stat:match("D") then
                    color_stat = red .. "D " .. reset
                elseif stat == "??" then
                    color_stat = cyan .. "??" .. reset
                end
                table.insert(results, color_stat .. "  |" .. file)
                seen[file] = true
            end
        end
        for _, file in ipairs(all_tracked) do
            local clean_file = file:gsub('^"(.*)"$', "%1")
            if not seen[clean_file] then
                table.insert(results, "    |" .. clean_file)
                seen[clean_file] = true
            end
        end
        return results
    end

    if picker_name == "git_files" or picker_name == "git_status" then
        local status_cmd, all_files_cmd
        if is_standard then
            status_cmd = "git status --porcelain -uall ."
            all_files_cmd = (picker_name == "git_files") and "git ls-files" or nil
        else
            status_cmd = string.format(
                "git --git-dir=%s --work-tree=%s status --porcelain -uall .",
                dot_git,
                home
            )
            all_files_cmd = (picker_name == "git_files")
                    and string.format(
                        "git --git-dir=%s --work-tree=%s ls-files",
                        dot_git,
                        home
                    )
                or nil
        end
        local results = get_jackpot_list(status_cmd, all_files_cmd, target_cwd)
        if picker_name == "git_files" then
            table.sort(results, function(a, b)
                return (a:match("|(.*)$") or "") < (b:match("|(.*)$") or "")
            end)
        end
        fzf.fzf_exec(results, {
            cwd = target_cwd,
            prompt = prompt_text .. (picker_name == "git_status" and "Status> " or ""),
            fzf_opts = {
                ["--ansi"] = "",
                ["--nth"] = "1..",
                ["--delimiter"] = "|",
                ["--color"] = "hl:-1,hl+:-1",
            },
            fn_selected = function(selected)
                if selected and selected[1] then
                    local file = selected[1]:match("|(.*)$")
                    local path = is_standard and (target_cwd .. "/" .. file)
                        or (home .. "/" .. file)
                    if selected[1]:match("D ") then
                        print("File is deleted: " .. file)
                    else
                        vim.cmd("edit " .. path)
                    end
                end
            end,
        })
        return
    end

    if picker_name == "live_grep" then
        local grep_cmd = is_standard
                and "rg --column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e"
            or string.format(
                "git --git-dir=%s --work-tree=%s grep --line-number --column --color=always",
                dot_git,
                home
            )
        fzf.live_grep({
            cwd = target_cwd,
            cmd = grep_cmd,
            prompt = "   Grep " .. (is_standard and "Project" or "Dotfiles") .. "> ",
        })
        return
    end

    fzf[picker_name]({
        cwd = target_cwd,
        git_dir = target_git_dir,
        git_worktree = target_worktree,
        prompt = prompt_text,
    })
end

return M
