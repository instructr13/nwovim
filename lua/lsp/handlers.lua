local M = {}

local function common(server_name, opts)
  opts = opts or {}

  require("lspconfig")[server_name].setup(vim.tbl_deep_extend("error", {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    on_attach = require("lsp.on_attach"),
  }, opts))
end

-- Register common handlers
M[1] = common

function M.lua_ls()
  require("neodev").setup()

  common("lua_ls", {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },
        hint = {
          enable = true,
        },
        telemetry = {
          enable = false,
        },
      },
    },
  })
end

-- Disable automatic jdtls setup by mason-lspconfig, we'll do it manually with
-- plugin/jdtls.lua
function M.jdtls() end

return M
