local C = require("packs.editor.config")

return {
  {
    -- improve word jump
    "chrisgrieser/nvim-spider",

    lazy = true,

    init = function()
      C.spider_setup()
    end,
  },
  {
    "tzachar/highlight-undo.nvim",

    keys = {
      "u",
      "<C-r>",
    },

    opts = {},
  },
  {
    "0xAdk/full_visual_line.nvim",

    keys = "V",

    opts = {},
  },
}
