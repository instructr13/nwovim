local C = require("packs.lsp.config")

local data_dir = require("constants.paths").data_dir
local join_paths = require("utils.paths").join_paths

return {
  {
    "williamboman/mason.nvim",

    lazy = true,

    cmd = "Mason",

    build = ":MasonUpdate",

    opts = function()
      require("mason-registry"):on(
        "package:install:success",
        vim.schedule_wrap(function(pkg)
          if pkg.name == "jdtls" then
            local base_path = join_paths(
              data_dir,
              "nwovim",
              "packages",
              "vscode-java-decompiler"
            )

            vim.notify("Installing vscode-java-decompiler used by jdtls")

            vim.system({
              "git",
              "clone",
              "--depth=1",
              "https://github.com/dgileadi/vscode-java-decompiler",
              base_path,
            }, { stdout = false }, function(obj)
              if obj.code == 0 and obj.signal == 0 then
                vim.notify("vscode-java-decompiler installed successfully")
              end
            end)
          end
        end)
      )

      return {
        ui = {
          border = "rounded",
        },
      }
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",

    event = { "BufReadPost", "BufNewFile" },

    opts = function()
      local handlers = require("lsp.handlers")

      require("neoconf")

      return {
        ensure_installed = { "lua_ls", "jsonls" },
        handlers = handlers,
      }
    end,

    dependencies = {
      "williamboman/mason.nvim",
      {
        "neovim/nvim-lspconfig",

        config = function()
          require("lspconfig.ui.windows").default_options.border = "rounded"
        end,
      },
      "b0o/SchemaStore.nvim",
    },
  },
  {
    "jay-babu/mason-null-ls.nvim",

    event = { "User NormalFile" },

    opts = {
      ensure_installed = { "stylua" },
      handlers = {
        function(source_name, methods)
          require("mason-null-ls.automatic_setup")(source_name, methods)
        end,
      },
    },

    dependencies = {
      "williamboman/mason.nvim",

      {
        "jose-elias-alvarez/null-ls.nvim",

        opts = function()
          local builtins = require("null-ls").builtins

          return {
            sources = {
              builtins.code_actions.gitsigns,
              builtins.code_actions.gitrebase,
              builtins.code_actions.impl, -- Go
              builtins.code_actions.refactoring,
              builtins.hover.dictionary,
              builtins.hover.printenv,
            },
          }
        end,
      },
    },
  },
  {
    "KostkaBrukowa/definition-or-references.nvim",

    lazy = true,

    opts = {
      on_references_result = function()
        vim.cmd("Trouble lsp_references")
      end,
    },
  },
  {
    "seblj/nvim-lsp-extras",

    event = { "User NormalFile" },

    opts = {
      signature = false,
    },
  },
  {
    "VidocqH/lsp-lens.nvim",

    event = { "LspAttach" },

    opts = {},
  },
  {
    "lukas-reineke/lsp-format.nvim",

    lazy = true,

    opts = {
      exclude = { "lua_ls" },
    },

    init = function()
      C.format_setup()
    end,
  },
  {
    "j-hui/fidget.nvim",

    tag = "legacy",

    event = { "LspAttach" },

    dependencies = { "nvim-tree/nvim-web-devicons" },

    opts = {
      sources = {
        ["null-ls"] = {
          ignore = true,
        },
      },
    },
  },
  {
    "folke/trouble.nvim",

    lazy = true,

    dependencies = { "nvim-tree/nvim-web-devicons" },

    opts = {
      use_diagnostic_signs = true,
    },
  },
  {
    "folke/neoconf.nvim",

    lazy = true,

    opts = {},
  },
}
