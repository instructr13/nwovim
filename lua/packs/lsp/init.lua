local C = require("packs.lsp.config")

return {
  {
    "neovim/nvim-lspconfig",

    lazy = true
  },
  {
    "williamboman/mason.nvim",

    event = { "BufReadPost", "BufNewFile" },

    cmd = "Mason",

    build = ":MasonUpdate",

    config = function()
      C.mason()
    end,

    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim"
      }
    }
  },
  {
    "seblj/nvim-lsp-extras",

    event = { "BufReadPost", "BufNewFile" },

    opts = {
      signature = false
    }
  },
  {
    "VidocqH/lsp-lens.nvim",

    event = { "LspAttach" },

    opts = {}
  },
  {
    "lukas-reineke/lsp-format.nvim",

    lazy = true,

    init = function()
      C.format_setup()
    end
  },
  {
    "lvimuser/lsp-inlayhints.nvim",

    lazy = true,

    init = function()
      C.inlayhints_setup()
    end
  },
  {
    "j-hui/fidget.nvim",

    event = { "LspAttach" },

    dependencies = { "nvim-tree/nvim-web-devicons" },

    opts = {
      sources = {
        ["null-ls"] = {
          ignore = true
        }
      }
    }
  },
  {
    "hrsh7th/nvim-linkedit",

    event = { "LspAttach" },

    opts = {}
  }
}
