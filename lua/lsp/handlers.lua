local M = {}

local function common(server_name, opts)
  opts = opts or {}

  local on_attach_fn

  if opts.on_attach then
    on_attach_fn = opts.on_attach
    opts.on_attach = nil
  else
    on_attach_fn = require("lsp.on_attach")
  end

  require("lspconfig")[server_name].setup(vim.tbl_deep_extend("error", {
    capabilities = require("lsp.capabilities").make_capabilities(),
    on_attach = on_attach_fn,
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

function M.tsserver()
  common("tsserver", {
    autostart = false,
    root_dir = require("lspconfig.util").root_pattern({
      "package.json",
      "tsconfig.json",
      "jsconfig.json",
    }),
    on_attach = require("lsp.on_attach"),
  })
end

function M.emmet_language_server()
  common("emmet_language_server", {
    filetypes = {
      "css",
      "eruby",
      "html",
      "javascript",
      "javascriptreact",
      "less",
      "sass",
      "scss",
      "pug",
      "typescriptreact",
      "vue",
      "astro",
    },
  })
end

-- Disable automatic Deno setup by mason-lspconfig, we'll do it manually with
-- opts field of deno-nvim
function M.denols() end

-- Disable automatic jdtls setup by mason-lspconfig, we'll do it manually with
-- init function of nvim-jdtls
function M.jdtls() end

-- Disable automatic rust-analyzer setup by mason-lspconfig, we'll do it
-- manually with opts field of rust-tools.nvim
function M.rust_analyzer() end

return M
