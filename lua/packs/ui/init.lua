local C = require("packs.ui.config")

return {
  {
    "catppuccin/nvim",

    name = "catppuccin",

    lazy = true,

    priority = 1000,

    opts = {
      flavour = "macchiato",
      background = {
        light = "latte",
        dark = "macchiato",
      },
      custom_highlights = function(_)
        return {
          SpellBad = {
            undercurl = false,
            underdashed = true,
          },
          MatchParen = {
            link = "IlluminatedWordText",
          },
          Search = {
            fg = "NONE",
          },
          IncSearch = {
            fg = "NONE",
          },
          DiagnosticUnderlineError = {
            fg = "NONE",
          },
          DiagnosticUnderlineWarn = {
            fg = "NONE",
          },
          DiagnosticUnderlineInfo = {
            fg = "NONE",
          },
          DiagnosticUnderlineHint = {
            fg = "NONE",
          },
          IndentBlanklineContextChar = {
            fg = "#f5bde6",
          },
          IndentBlanklineContextStart = {
            sp = "#f5bde6",
          },
        }
      end,
      integrations = {
        gitsigns = true,
        markdown = true,
        mason = true,
        neotree = true,
        neotest = true,
        noice = true,
        headlines = true,
        cmp = true,
        fidget = true,
        dap = {
          enabled = true,
          enable_ui = true,
        },
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
            hints = { "underdotted" },
          },
        },
        dropbar = {
          enabled = true,
        },
        barbecue = {
          dim_dirname = true,
          bold_basename = false,
          dim_context = false,
        },
        navic = {
          enabled = true,
          custom_bg = "NONE",
        },
        notify = true,
        treesitter_context = true,
        treesitter = true,
        ts_rainbow2 = true,
        telescope = true,
        illuminate = true,
        indent_blankline = {
          enabled = true,
          colored_indent_levels = true,
        },
      },
    },
  },
  {
    "stevearc/dressing.nvim",

    event = "VeryLazy",

    opts = {
      input = {
        enabled = true,

        border = "rounded",
      },
      select = {
        enabled = true,

        nui = {
          border = {
            style = "rounded",
          },
        },
      },
    },
  },
  {
    "folke/noice.nvim",

    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",

        config = function()
          C.notify()
        end,
      },
    },

    opts = {
      lsp = {
        progress = {
          enabled = false,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        --inc_rename = true,
        lsp_doc_border = true,
      },
    },
  },
  {
    -- Statusline
    "rebelot/heirline.nvim",

    event = "BufEnter",

    dependencies = {
      {
        "jonahgoldwastaken/copilot-status.nvim",

        dependencies = {
          "copilot.lua",
        },

        opts = {
          icons = {
            idle = " ",
            error = " ",
            offline = " ",
            warning = " ",
            loading = " ",
          },
        },
      },
    },

    config = function()
      C.statusline()
    end,
  },
  {
    -- Bufferline
    "akinsho/bufferline.nvim",

    version = "*",

    event = "BufEnter",

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    config = function()
      C.bufferline()
    end,
  },
  {
    -- Winbar
    "Bekaboo/dropbar.nvim",

    enabled = vim.fn.has("NVIM-0.10") == 1,

    event = "User NormalFile",

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    opts = {
      icons = {
        enable = true,
        kinds = {
          symbols = require("constants.lsp.kind"),
        },
        ui = {
          bar = {
            separator = "  ",
            extends = "…",
          },
          menu = {
            separator = " ",
            indicator = "",
          },
        },
      },
    },
  },
  {
    -- Winbar <= NVIM-0.9
    "utilyre/barbecue.nvim",

    version = "*",

    enabled = vim.fn.has("NVIM-0.10") ~= 1,

    event = "User NormalFile",

    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },

    config = function()
      C.barbecue()
    end,
  },
  {
    "lewis6991/satellite.nvim",

    event = "User NormalFile",

    opts = {
      excluded_filetypes = { "neo-tree" },
    },
  },
  {
    -- Statuscolumn added by NVIM-0.9
    "luukvbaal/statuscol.nvim",

    lazy = true,

    opts = function()
      local builtin = require("statuscol.builtin")

      return {
        bt_ignore = { "nofile", "terminal" },
        relculright = true,
        segments = {
          {
            sign = {
              name = { "Dap.*" },
              maxwidth = 1,
              colwidth = 1,
            },
          },
          {
            sign = {
              name = { "Diagnostic" },
              maxwidth = 1,
              colwidth = 2,
            },
            click = "v:lua.ScSa",
          },
          {
            sign = {
              name = { ".*" }, -- table of lua patterns to match the sign name against
              auto = true,
              wrap = true,
            },
          },
          {
            text = { builtin.lnumfunc, " " },
            click = "v:lua.ScLa",
          },
          {
            sign = {
              name = { "GitSigns.*" },
            },
            click = "v:lua.ScSa",
          },
          {
            text = { builtin.foldfunc },
            click = "v:lua.ScFa",
          },
          { text = { " " } },
          {
            sign = {
              name = { "LightbulbSign" },
              maxwidth = 1,
              colwidth = 1,
            },
            click = "v:lua.ScSa",
          },
          { text = { " │" } },
        },
        clickhandlers = {
          LightbulbSign = function(args)
            if args.button == "l" then
              vim.lsp.buf.code_action()
            end
          end,
        },
      }
    end,
  },
  {
    "mawkler/modicator.nvim",

    event = "ModeChanged",

    opts = {
      show_warnings = false,
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",

    event = { "BufReadPre", "BufNewFile" },

    dependencies = {
      "TheGLander/indent-rainbowline.nvim",
    },

    opts = function()
      return require("indent-rainbowline").make_opts({
        char = "▏",
        context_char = "▏",
        show_current_context = true,
        show_current_context_start = true,
        show_first_indent_level = false,
      })
    end,
  },
  {
    "folke/which-key.nvim",

    event = "VeryLazy",

    opts = {}
  },
}
