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
            underdashed = true
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
        }
      end,
      integrations = {
        gitsigns = true,
        markdown = true,
        mason = true,
        neotree = true,
        neotest = true,
        noice = true,
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
          enabled = true
        },
        barbecue = {
          dim_dirname = true,
          bold_basename = false,
          dim_context = false
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
          colored_indent_levels = true
        }
      }
    }
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
    }
  },
  {
    "folke/noice.nvim",

    dependencies = {
      "MunifTanjim/nui.nvim",
      {
        "rcarriga/nvim-notify",

        config = function()
          C.notify()
        end
      }
    },

    opts = {
      lsp = {
        progress = {
          enabled = false
        },
        override = {
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
        lsp_doc_border = true,
      },
    }
  },
  {
    -- Statusline
    "rebelot/heirline.nvim",

    event = { "UIEnter" },

    config = function()
      C.statusline()
    end
  },
  --[[
  {
    -- Statusline
    "strash/everybody-wants-that-line.nvim",

    event = { "UIEnter" },

    opts = {
      filepath = {
        enabled = false -- Barbecue handles this
      },
      filename = {
        enabled = false
      }
    }
  },
  ]]
  {
    -- Bufferline
    "akinsho/bufferline.nvim",

    version = "*",

    event = { "Colorscheme" },

    dependencies = {
      "nvim-tree/nvim-web-devicons"
    },

    config = function()
      C.bufferline()
    end
  },
  {
    -- Winbar
    "Bekaboo/dropbar.nvim",

    enabled = vim.fn.has("NVIM-0.10") == 1,

    event = { "BufReadPost", "BufNewFile" },

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    opts = {
      icons = {
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
      }
    }
  },
  {
    -- Winbar <= NVIM-0.9
    "utilyre/barbecue.nvim",

    version = "*",

    enabled = vim.fn.has("NVIM-0.10") ~= 1,

    event = { "BufReadPost", "BufNewFile" },

    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },

    config = function()
      C.barbecue()
    end
  },
  {
    -- Statuscolumn added by NVIM-0.9
    "luukvbaal/statuscol.nvim",

    event = { "VeryLazy" },

    config = function()
      C.statuscol()
    end
  },
  {
    "mawkler/modicator.nvim",

    event = { "ModeChanged" },

    opts = {
      show_warnings = false
    }
  }
}
