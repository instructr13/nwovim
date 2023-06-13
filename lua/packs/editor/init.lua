local C = require("packs.editor.config")

return {
  {
    "RRethy/vim-illuminate",

    event = { "CursorMoved" },
  },
  {
    "andymass/vim-matchup",

    event = { "BufReadPre", "BufNewFile" },

    init = function()
      C.matchup_setup()
    end,
  },
  {
    -- improve word jump
    "chrisgrieser/nvim-spider",

    lazy = true,

    init = function()
      C.spider_setup()
    end,
  },
  {
    -- colorcolumn
    "Bekaboo/deadcolumn.nvim",

    event = { "BufReadPre", "CursorMoved" },

    opts = {
      "cursor",
    },
  },
  {
    "altermo/ultimate-autopair.nvim",

    event = { "InsertEnter", "CmdlineEnter" },

    opts = {},
  },
  --[[
  {
    "altermo/npairs-integrate-upair",

    event = { "InsertEnter", "CmdlineEnter" },

    opts = {
      npairs_conf = {
        enable_abbr = true
      }
    },

    dependencies = {
      "windwp/nvim-autopairs",
      "altermo/ultimate-autopair.nvim"
    }
  }
  ]]
}
