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
  {
    "nkakouros-original/scrollofffraction.nvim",

    opts = {
      scrolloff_fraction = 0.3,
      scrolloff_absolute_value = 4,
    },
  },
  {
    "HakonHarnes/img-clip.nvim",

    event = "BufEnter",

    opts = {},
  },
}
