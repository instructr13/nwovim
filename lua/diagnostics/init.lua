local M = {}

local icons = {
  Error = "",
  Warn = "",
  Info = "",
  Hint = "",
}

local function set_virtual_text_prefix()
  vim.diagnostic.config({
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

local function set_border()
  vim.diagnostic.config({
    float = {
      border = "rounded",
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
  set_virtual_text_prefix()
  set_border()
  define_signs()
end

return M
