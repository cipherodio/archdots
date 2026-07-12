local M = {}

local state_home = vim.env.XDG_STATE_HOME or (vim.env.HOME .. "/.local/state")

local theme_state = state_home .. "/theme/current"

function M.mode()
    local file = io.open(theme_state, "r")

    if not file then
        return "dark"
    end

    local mode = vim.trim(file:read("*l") or "")
    file:close()

    if mode == "light" then
        return "light"
    end

    return "dark"
end

return M
