local M = {}

M.neo_tree = {}

-- Handles file rename events only for tsserver
function M.neo_tree.on_file_move(args)
  local clients = vim.lsp.get_active_clients({ name = "tsserver" })

  for _, client in ipairs(clients) do
    client.request("workspace/executeCommand", {
      command = "_typescript.applyRenameFile",
      arguments = {
        {
          sourceUri = vim.uri_from_fname(args.source),
          targetUri = vim.uri_from_fname(args.destination),
        },
      },
    })
  end
end

return M
