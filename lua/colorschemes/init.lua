local M = {}

local DEFAULT_COLOR_SCHEME = "catppuccin"

-- TODO: make colorschemes selectable

function M.setup()
  pcall(require(string.format("colorschemes.%s", DEFAULT_COLOR_SCHEME)))
end

return M

