local C = require("packs.lang.config")

return {
  -- Lua
  {
    "folke/neodev.nvim",

    lazy = true,
  },
  -- Java
  {
    "mfussenegger/nvim-jdtls",

    lazy = true,
  },
  -- Markdown
  {
    "atusy/tsnode-marker.nvim",

    lazy = true,

    init = function()
      C.tsnode_marker_setup()
    end,
  },
  {
    "lukas-reineke/headlines.nvim",

    ft = { "markdown", "norg" },

    dependencies = "nvim-treesitter/nvim-treesitter",

    opts = {},
  },
}
