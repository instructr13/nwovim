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

    init = function()
      local keymap = require("utils.keymap").keymap

      keymap("n", "<C-k>", function()
        require("ts-node-action").node_action()
      end, "Trigger Node Action")
    end,

    opts = {},
  },
}
