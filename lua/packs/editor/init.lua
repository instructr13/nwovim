local C = require("packs.editor.config")

return {
  {
    "RRethy/vim-illuminate",

    event = { "CursorMoved" },
  },
  {
    "andymass/vim-matchup",

    event = { "BufReadPre", "BufNewFile" },

    init = C.matchup_setup
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
