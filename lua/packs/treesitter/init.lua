local C = require("packs.treesitter.config")

return {
  {
    "nvim-treesitter/nvim-treesitter",

    version = false,

    build = ":TSUpdate",

    event = { "BufReadPost", "BufNewFile", "CmdlineChanged" },

    dependencies = {
      "HiPhish/nvim-ts-rainbow2",
      "windwp/nvim-ts-autotag",
      "RRethy/nvim-treesitter-endwise",
      { "yioneko/nvim-yati", version = false },
    },

    config = function()
      C.treesitter()
    end,
  },
  {
    "ThePrimeagen/refactoring.nvim",

    lazy = true,

    opts = {},
  },
  {
    "CKolkey/ts-node-action",

    lazy = true,

    cmd = "NodeAction",

    init = function()
      local keymap = require("utils.keymap").keymap

      keymap("n", "<C-s>", function()
        vim.cmd("NodeAction")
      end, "Trigger Node Action")
    end,

    dependencies = {
      {
        "tpope/vim-repeat",

        lazy = false,
      },
    },

    opts = {},
  },
}
