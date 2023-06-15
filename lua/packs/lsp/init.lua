local C = require("packs.lsp.config")

return {
  {
    "williamboman/mason.nvim",

    lazy = true,

    cmd = "Mason",

    build = ":MasonUpdate",

    opts = {
      ui = {
        border = "rounded",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",

    event = { "BufReadPre", "BufNewFile" },

    opts = function()
      local handlers = require("lsp.handlers")

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
    },
  },
  {
    "jay-babu/mason-null-ls.nvim",

    event = { "BufReadPre", "BufNewFile" },

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
    "seblj/nvim-lsp-extras",

    event = { "BufReadPost", "BufNewFile" },

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
    "lvimuser/lsp-inlayhints.nvim",

    lazy = true,

    init = function()
      C.inlayhints_setup()
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
}
