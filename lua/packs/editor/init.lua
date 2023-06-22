local C = require("packs.editor.config")

return {
  {
    -- Dashboard
    "goolord/alpha-nvim",

    lazy = true,

    cmd = { "Alpha" },

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    init = function()
      C.alpha_setup()
    end,

    opts = function()
      return require("alpha.themes.dashboard").config
    end,
  },
  {
    "RRethy/vim-illuminate",

    lazy = true,

    init = function()
      vim.api.nvim_create_autocmd({ "CursorMoved" }, {
        group = vim.api.nvim_create_augroup(
          "illuminate_init",
          { clear = true }
        ),
        callback = function(opts)
          if vim.bo[opts.buf].buftype ~= "" then
            return
          end

          require("illuminate") -- Load

          vim.api.nvim_del_augroup_by_name("illuminate_init")
        end,
      })
    end,
  },
  {
    "andymass/vim-matchup",

    event = { "User NormalFile" },

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

    event = { "CursorMoved" },

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
      { "gc", mode = { "n", "v" } },
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

    lazy = true,
  },
  {
    "ethanholz/nvim-lastplace",

    opts = {},
  },
}
