local null_ls = require("null-ls")

local M = {}

function M.register_with(source, types, opts)
  if null_ls.is_registered(source) then
    return
  end

  vim.tbl_map(function(type)
    null_ls.register(null_ls.builtins[type][source].with(opts))
  end, types)
end

return M
