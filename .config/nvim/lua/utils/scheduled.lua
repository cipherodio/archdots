local M = {}

-- Validate YYYY-MM-DD
local function validate_date(date)
    return type(date) == "string" and date:match("^%d%d%d%d%-%d%d%-%d%d$")
end

-- Insert line below a fixed row (absolute, cursor-independent)
local function insert_line_below(base_row, line)
    local buf = 0

    -- base_row is 1-based, buf_set_lines is 0-based
    vim.api.nvim_buf_set_lines(buf, base_row, base_row, false, { line })

    local target_row = base_row + 1
    local col = string.find(line, "%[ %]") + 3

    vim.api.nvim_win_set_cursor(0, { target_row, col })
    vim.cmd.startinsert()
end

-- Single checkbox
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
            vim.notify("Invalid date format. Use YYYY-MM-DD.", vim.log.levels.ERROR)
            return
        end

        local line = "- [ ]  @" .. tag .. "(" .. date .. ")"
        insert_line_below(base_row, line)
    end)
end

-- Scheduled + Deadline
function M.insert_scheduled_and_deadline_checkbox()
    local base_row = vim.api.nvim_win_get_cursor(0)[1]

    vim.ui.input({
        prompt = "Scheduled date (YYYY-MM-DD): ",
        default = os.date("%Y-%m-%d"),
    }, function(scheduled_date)
        if not scheduled_date or scheduled_date == "" then
            return
        end

        if not validate_date(scheduled_date) then
            vim.notify("Invalid scheduled date format.", vim.log.levels.ERROR)
            return
        end

        vim.ui.input({
            prompt = "Deadline date (YYYY-MM-DD): ",
            default = scheduled_date,
        }, function(deadline_date)
            if not deadline_date or deadline_date == "" then
                return
            end

            if not validate_date(deadline_date) then
                vim.notify("Invalid deadline date format.", vim.log.levels.ERROR)
                return
            end

            local line = "- [ ]  @scheduled("
                .. scheduled_date
                .. ") @deadline("
                .. deadline_date
                .. ")"

            insert_line_below(base_row, line)
        end)
    end)
end

-- Public API
function M.insert_scheduled_checkbox()
    prompt_and_insert("scheduled", "Scheduled")
end

function M.insert_deadline_checkbox()
    prompt_and_insert("deadline", "Deadline")
end

return M
