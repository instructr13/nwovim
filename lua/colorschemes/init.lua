local M = {}

M.default_colorscheme = "catppuccin"

function M.setup()
  if vim.g.vscode then
    return
  end

  pcall(require(string.format("colorschemes.%s", M.default_colorscheme)))
end

return M
