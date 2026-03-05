local M = {}

-- Helper to use Fzf-lua as a pure input prompt
local function fzf_input(prompt, default, callback)
    local fzf = require("fzf-lua")

    fzf.fzf_exec({ "Confirm: " .. default }, {
        prompt = prompt .. " ",
        winopts = { height = 0.15, width = 0.40, row = 0.40, border = "single" },
        fzf_opts = { ["--query"] = default, ["--print-query"] = true },
        actions = {
            ["default"] = function()
                local new = fzf.get_last_query()
                if new then
                    new = new:gsub("%s+$", "")
                    vim.schedule(function()
                        callback(new)
                    end)
                end
            end,
        },
    })
end

-- Fast replace every same word in a file via Fzf-lua
function M.replace_word_fast()
    local old = vim.fn.expand("<cword>")

    if old == "" then
        return
    end
    fzf_input("Replace with:", old, function(new)
        if not new or new == "" or new == old then
            return
        end
        local cmd = string.format(
            "%%s/\\<%s\\>/%s/gI",
            vim.pesc(old),
            vim.fn.escape(new, [[\/&]])
        )
        if pcall(function()
            vim.cmd(cmd)
        end) then
            vim.cmd("redraw")
            print("Successfully replaced '" .. old .. "' with '" .. new .. "'")
        end
    end)
end

-- Use tab to select which word will be replace via Fzf-lua
function M.replace_word_confirm()
    local old = vim.fn.expand("<cword>")

    if old == "" then
        return
    end
    fzf_input("Replace with:", old, function(new)
        if not new or new == "" or new == old then
            return
        end
        vim.cmd(string.format("silent! vimgrep /\\<%s\\>/g %%", vim.pesc(old)))
        require("fzf-lua").quickfix({
            prompt = "Tab: Select | A-a: All | A-d: None | Enter: Replace > ",
            keymap = {
                fzf = {
                    ["ctrl-a"] = "select-all",
                    ["ctrl-d"] = "deselect-all",
                },
            },
            fzf_opts = { ["--multi"] = true },
            actions = {
                ["default"] = function(selected)
                    if not selected or #selected == 0 then
                        return
                    end
                    for i = #selected, 1, -1 do
                        local entry = selected[i]
                        local lnum = entry:match(":(%d+):")
                            or entry:match("|(%d+)|")
                            or entry:match(":(%d+) ")
                        if lnum then
                            local cmd = string.format(
                                "%ss/\\<%s\\>/%s/g",
                                lnum,
                                vim.pesc(old),
                                vim.fn.escape(new, [[\/&]])
                            )
                            vim.api.nvim_command(cmd)
                        end
                    end
                    vim.cmd("cclose")
                    vim.cmd("redraw")
                    print("Surgical replace complete.")
                end,
            },
        })
    end)
end

return M
