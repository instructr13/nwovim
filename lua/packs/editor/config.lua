local M = {}

function M.matchup_setup()
  vim.g.matchup_matchparen_offscreen = {
    method = "scrolloff"
  }

  vim.g.matchup_matchparen_defferred = 1
end

return M
