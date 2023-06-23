local M = {}

local function common(server_name, opts)
  opts = opts or {}

  require("lspconfig")[server_name].setup(vim.tbl_deep_extend("error", {
    capabilities = require("lsp.capabilities").make_capabilities(),
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

function M.jsonls()
  common("jsonls", {
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  })
end

function M.yamlls()
  common("yamlls", {
    settings = {
      yaml = {
        schemaStore = {
          enable = false,
        },
        schemas = require("schemastore").yaml.schemas(),
      },
    },
  })
end

-- Disable automatic jdtls setup by mason-lspconfig, we'll do it manually with
-- init function of nvim-jdtls
function M.jdtls() end

-- Disable automatic jdtls setup by mason-lspconfig, we'll do it manually with
-- opts field of rust-tools.nvim
function M.rust_analyzer() end

return M
