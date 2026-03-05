local M = {}

-- Check current deepseek balance
function M.check_deepseek_balance()
    local api_key = os.getenv("DEEPSEEK_API_KEY") or os.getenv("LLM_KEY")
    if not api_key or api_key == "" then
        print("Error: No API Key found.")
        return
    end
    print("Checking balance... 󰔟")
    local cmd = string.format(
        "curl -s -X GET 'https://api.deepseek.com/user/balance' "
            .. "-H 'Authorization: Bearer %s' | "
            .. 'jq -r \'.balance_infos[0] | "󰇁" + .total_balance + " " + .currency\'',
        api_key
    )
    local output = {}

    vim.fn.jobstart({ "sh", "-c", cmd }, {
        stdout_buffered = true,
        on_stdout = function(_, data)
            if data then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        table.insert(output, line)
                    end
                end
            end
        end,
        on_exit = function(_, code)
            vim.schedule(function()
                local result =
                    table.concat(output, " "):gsub("%s+", " "):gsub("^%s*(.-)%s*$", "%1")
                if code == 0 and result ~= "" and result ~= "null" then
                    print(result)
                else
                    print("Failed to fetch balance. Check your API key or credits.")
                end
            end)
        end,
    })
end

return M
