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

          require("illuminate").configure({
            filetypes_denylist = {
              "CodeAction",
              "dirvish",
              "fugitive",
            },
          })

          vim.api.nvim_del_augroup_by_name("illuminate_init")
        end,
      })
    end,
  },
  {
    "hiphish/rainbow-delimiters.nvim",

    event = { "User NormalFile" },

    config = function()
      local rainbow_delimiters = require("rainbow-delimiters")

      require("rainbow-delimiters.setup").setup({
        strategy = {
          [""] = rainbow_delimiters.strategy["global"],
          vim = rainbow_delimiters.strategy["local"],
        },
        query = {
          [""] = "rainbow-delimiters",
          latex = "rainbow-blocks",
          lua = "rainbow-blocks",
        },
        highlight = {
          "RainbowDelimiterRed",
          "RainbowDelimiterYellow",
          "RainbowDelimiterBlue",
          "RainbowDelimiterOrange",
          "RainbowDelimiterGreen",
          "RainbowDelimiterViolet",
          "RainbowDelimiterCyan",
        },
      })

      -- Manually enable for first loading
      local lang = vim.treesitter.language.get_lang(vim.bo.filetype)

      if require("rainbow-delimiters.config").enabled_for(lang) then
        require("rainbow-delimiters.lib").attach(vim.api.nvim_get_current_buf())
      end
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

    config = function()
      local ultimate_autopair = require("ultimate-autopair")
      local utils = require("ultimate-autopair.utils")

      ultimate_autopair.setup()

      local key_bs = vim.api.nvim_replace_termcodes("<BS>", true, false, true)

      ultimate_autopair.init({
        ultimate_autopair.extend_default({
          bs = {
            space = "balance",
            indent_ignore = true,
          },
          fastwarp = {
            multi = true,
            {},
            {
              faster = true,
              map = "<C-A-e>",
              cmap = "<C-A-e>",
            },
          },
        }),
        {
          profile = "raw",
          {
            p = 2,
            check = function(o)
              if o.key ~= key_bs or o.incmd then
                return
              end

              if o.line:sub(1, o.col - 1):find("[^%s]") then
                return
              end

              if o.col == 1 then
                return
              end

              local prev_line = o.lines[o.row - 1]

              if not prev_line then
                return
              end

              if prev_line:gsub("%s+", "") ~= "" then
                return utils.create_act({
                  { "home" },
                  { "delete", 1, o.col - 1 },
                })
              end

              return utils.create_act({
                { "home" },
                { "delete", 1, #prev_line },
                { "l", o.col - 1 - #prev_line },
              })
            end,
            get_map = function(mode)
              return mode == "i" and { "<BS>" }
            end,
          },
        },
      })
    end,
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
  {
    "0xAdk/full_visual_line.nvim",

    keys = "V",

    opts = {},
  },
  {
    "VidocqH/auto-indent.nvim",

    opts = {},
  },
  {
    "chrisgrieser/nvim-puppeteer",
  },
}
