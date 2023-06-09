local M = {}

local function define_signs()
  vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticError" })
  vim.fn.sign_define("DiagnosticSignWarn",  { text = "", texthl = "DiagnosticWarn" })
  vim.fn.sign_define("DiagnosticSignInfo",  { text = "", texthl = "DiagnosticInfo" })
  vim.fn.sign_define("DiagnosticSignHint",  { text = "", texthl = "DiagnosticHint" })
end

function M.setup()
  define_signs()
end

return M

