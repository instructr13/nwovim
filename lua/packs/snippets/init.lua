local C = require("packs.snippets.config")

local is_windows = require("utils.os").is_windows

return {
  {
    "L3MON4D3/LuaSnip",

    lazy = true,

    run = not is_windows and "make install_jsregexp" or "",

    config = function()
      C.luasnip()
    end,

    dependencies = {
      "rafamadriz/friendly-snippets",
    },
  },
  {
    "evesdropper/luasnip-latex-snippets.nvim",

    ft = { "tex", "markdown" },

    dependencies = {
      "LuaSnip", -- TODO: include vimtex
    },
  },
}
