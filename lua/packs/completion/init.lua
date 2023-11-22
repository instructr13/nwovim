local C = require("packs.completion.config")

return {
  {
    "hrsh7th/nvim-cmp",

    event = { "InsertEnter", "CmdlineEnter" },

    dependencies = {
      { "saadparwaiz1/cmp_luasnip" },
      { "lukas-reineke/cmp-under-comparator" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lsp-document-symbol" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-emoji" },
      {
        "petertriho/cmp-git",

        dependencies = {
          "nvim-lua/plenary.nvim",
        },

        opts = {},
      },
      { "rcarriga/cmp-dap" },
      { "FelipeLema/cmp-async-path" },
      { "hrsh7th/cmp-cmdline" },
    },

    opts = function()
      return C.cmp_opts()
    end,
  },
  {
    "zbirenbaum/copilot-cmp",

    lazy = true,

    dependencies = {
      "zbirenbaum/copilot.lua",

      cmd = "Copilot",

      opts = {
        suggestion = {
          enabled = false,
        },
        panel = {
          enabled = false,
        },
      },
    },

    opts = {},
  },
}
