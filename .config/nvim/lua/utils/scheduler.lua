local M = {}

-- Validate YYYY-MM-DD
local function validate_date(date)
    return type(date) == "string" and date:match("^%d%d%d%d%-%d%d%-%d%d$")
end

local function insert_line_below(base_row, line)
    local buf = 0

    vim.api.nvim_buf_set_lines(buf, base_row, base_row, false, { line })
    local target_row = base_row + 1
    local col = 6
    vim.api.nvim_win_set_cursor(0, { target_row, col })
    vim.cmd.startinsert()
end

-- Single checkbox for @scheduled or @deadline
local function prompt_and_insert(tag, label)
    local base_row = vim.api.nvim_win_get_cursor(0)[1]

    vim.ui.input({
        prompt = label .. " date (YYYY-MM-DD): ",
        default = os.date("%Y-%m-%d"),
    }, function(date)
        if not date or date == "" then
            return
        end
        if not validate_date(date) then
            vim.notify("Invalid date format.", vim.log.levels.ERROR)
            return
        end
        local line = "- [ ]  @" .. tag .. "(" .. date .. ")"
        insert_line_below(base_row, line)
    end)
end

-- For both @scheduled and @deadline
function M.insert_scheduled_and_deadline()
    local base_row = vim.api.nvim_win_get_cursor(0)[1]

    vim.ui.input({
        prompt = "Scheduled date (YYYY-MM-DD): ",
        default = os.date("%Y-%m-%d"),
    }, function(sd)
        if not sd or sd == "" then
            return
        end
        if not validate_date(sd) then
            vim.notify("Invalid scheduled date.", vim.log.levels.ERROR)
            return
        end
        vim.ui.input({
            prompt = "Deadline date (YYYY-MM-DD): ",
            default = sd,
        }, function(dd)
            if not dd or dd == "" then
                return
            end
            if not validate_date(dd) then
                vim.notify("Invalid deadline date.", vim.log.levels.ERROR)
                return
            end
            local line = "- [ ]  @scheduled(" .. sd .. ") @deadline(" .. dd .. ")"
            insert_line_below(base_row, line)
        end)
    end)
end

function M.insert_scheduled()
    prompt_and_insert("scheduled", "Scheduled")
end
function M.insert_deadline()
    prompt_and_insert("deadline", "Deadline")
end

return M
