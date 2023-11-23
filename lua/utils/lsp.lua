local M = {}

function M.list_workspace_folders()
  local bullet = "  - "
  local workspace_folders =
    table.concat(vim.lsp.buf.list_workspace_folders(), "\n" .. bullet)

  if workspace_folders == "" then
    workspace_folders = "None"
  end

  vim.notify(
    "List of workspace folders:\n"
      .. (workspace_folders ~= "" and bullet or "")
      .. workspace_folders,
    vim.log.levels.INFO,
    { title = "lsp" }
  )
end

function M.find_client(name)
  for _, client in ipairs(vim.lsp.get_active_clients()) do
    if client.name == name then
      return client
    end
  end
end

-- Disable notification of client detach
function M.detach_silently(bufnr, id)
  local original_notify = vim.notify

  vim.notify = function(...) end

  vim.lsp.buf_detach_client(bufnr, id)

  vim.notify = original_notify
end

return M
