local M = {}

function M.exec(event)
  vim.schedule(function()
    vim.api.nvim_exec_autocmds("User", { pattern = event, modeline = false })
  end)
end

return M
