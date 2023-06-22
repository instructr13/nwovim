local C = require("packs.treesitter.config")

return {
  {
    "nvim-treesitter/nvim-treesitter",

    version = false,

    build = ":TSUpdate",

    event = { "User NormalFile", "CmdlineChanged" },

    cmd = {
      "TSInstall",
      "TSUninstall",
      "TSInstallSync",
      "TSInstallInfo",
      "TSUpdate",
    },

    dependencies = {
      {
        "LiadOz/nvim-dap-repl-highlights",

        opts = {},
      },
      "HiPhish/nvim-ts-rainbow2",
      "windwp/nvim-ts-autotag",
      "RRethy/nvim-treesitter-endwise",
      "nvim-treesitter/playground",
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
  {
    "ziontee113/syntax-tree-surfer",

    keys = {
      "vU",
      "vD",
      "vd",
      "vu",
    },

    cmd = {
      "STSSwapOrHold",
      "STSSwapOrHoldVisual",
    },

    lazy = true,

    config = function()
      C.syntax_tree_surfer()
    end,

    init = function()
      C.syntax_tree_surfer_setup()
    end,
  },
}
