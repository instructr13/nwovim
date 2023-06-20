local C = require("packs.editor.config")

return {
  {
    -- Dashboard
    "goolord/alpha-nvim",

    event = "VimEnter",

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    opts = function()
      return require("alpha.themes.dashboard").config
    end,
  },
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
    "abecodes/tabout.nvim",

    event = "InsertEnter",

    opts = {},
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
  {
    "numToStr/Comment.nvim",

    keys = {
      "gc",
      "gb",
      "gcO",
      "gco",
      "gcA",
    },

    opts = function()
      return {
        pre_hook = require(
          "ts_context_commentstring.integrations.comment_nvim"
        ).create_pre_hook(),
      }
    end,

    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
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
    "lewis6991/fileline.nvim",
  },
  {
    "ethanholz/nvim-lastplace",

    opts = {}
  },
}
