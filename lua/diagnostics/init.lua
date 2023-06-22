local M = {}

local icons = {
  Error = "",
  Warn = "",
  Info = "",
  Hint = "",
}
local function config_diagnostic()
  vim.diagnostic.config({
    float = {
      border = "rounded",
    },
    signs = false,
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = vim.fn.has("nvim-0.10") == 0 and "●" or function(diagnostic)
        for severity, icon in pairs(icons) do
          if
              diagnostic.severity == vim.diagnostic.severity[severity:upper()]
          then
            return icon .. " "
          end
        end
      end,
    },
  })
end

local function define_signs()
  for name, icon in pairs(icons) do
    name = "DiagnosticSign" .. name

    vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
  end
end

function M.setup()
  config_diagnostic()
  define_signs()
end

return M
