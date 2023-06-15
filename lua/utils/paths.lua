local M = {}

local path_sep = require("constants.paths").path_sep

function M.join_paths(...)
  return table.concat({ ... }, path_sep)
end

return M
