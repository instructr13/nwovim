local C = require("packs.ui.config")
local fn = vim.fn

return {
  {
    "catppuccin/nvim",

    name = "catppuccin",

    lazy = true,

    priority = 1000,

    opts = {
      flavour = "mocha",
      background = {
        light = "latte",
        dark = "mocha",
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

    init = function()
      local keymap = require("utils.keymap").keymap

      keymap("n", "<leader>H", "<cmd>Noice telescope<cr>", "Messages History")

      require("utils.telescope").register_extension("noice")
    end,

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

    dependencies = {},

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

    opts = function()
      local groups = require("bufferline.groups")

      -- Set indicator color
      vim.cmd.hi({ "TabLineSel guibg=#ed8796", bang = true })

      local offset = require("bufferline.offset")

      if not offset.edgy then
        local original_get = offset.get

        offset.get = function()
          if package.loaded.edgy then
            local layout = require("edgy.config").layout
            local ret = { left = "", left_size = 0, right = "", right_size = 0 }

            for _, pos in ipairs({ "left", "right" }) do
              local sb = layout[pos]

              if sb and #sb.wins > 0 then
                local title = " Sidebar" .. string.rep(" ", sb.bounds.width - 8)
                ret[pos] = "%#EdgyTitle#"
                  .. title
                  .. "%*"
                  .. "%#WinSeparator#│%*"
                ret[pos .. "_size"] = sb.bounds.width
              end
            end

            ret.total_size = ret.left_size + ret.right_size

            if ret.total_size > 0 then
              return ret
            end
          end

          return original_get()
        end

        offset.edgy = true
      end

      local keymap = require("utils.keymap").keymap

      keymap("n", "gb", function()
        require("bufferline").pick()
      end, "Pick Buffer")

      return {
        highlights = require("catppuccin.groups.integrations.bufferline").get({
          styles = { "italic" },
          custom = {
            all = {
              fill = {
                bg = {
                  attribute = "bg",
                  highlight = "StatusLine",
                },
              },
            },
          },
        }),
        options = {
          close_command = function(bufnr)
            require("mini.bufremove").delete(bufnr, true)
          end,
          right_mouse_command = "vertical sbuffer %d",
          indicator = {
            style = "underline",
          },
          diagnostics = "nvim_lsp",
          diagnostics_update_in_insert = true,
          diagnostics_indicator = function(count, level)
            if level:match("error") then
              return " " .. count
            elseif level:match("warning") then
              return " " .. count
            end

            return ""
          end,
          get_element_icon = function(element)
            local icon, hl = require("nvim-web-devicons").get_icon_by_filetype(
              element.filetype,
              { default = false }
            )

            return icon, hl
          end,
          groups = {
            options = {
              toggle_hidden_on_enter = true,
            },
            items = {
              {
                name = "tests",
                priority = 2,
                icon = " ",
                matcher = function(buf)
                  return buf.path:match("%_test") or buf.path:match("%_spec")
                end,
              },
              groups.builtin.ungrouped,
              {
                name = "docs",
                icon = " ",
                matcher = function(buf)
                  return vim.tbl_contains({
                    "md",
                    "mdx",
                    "rst",
                    "txt",
                    "wiki",
                  }, fn.fnamemodify(buf.path, ":e"))
                end,
              },
            },
          },
          hover = {
            enabled = true,
            delay = 200,
            reveal = { "close" },
          },
        },
      }
    end,
  },
  {
    -- Winbar
    "Bekaboo/dropbar.nvim",

    version = "*",

    enabled = vim.fn.has("NVIM-0.10") == 1,

    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },

    opts = {
      general = {
        update_events = {
          win = {
            "CursorMoved",
            "CursorMovedI",
            "WinEnter",
          },
        },
      },
      menu = {
        keymaps = {
          ["<ESC>"] = function()
            local menu = require("dropbar.utils").menu.get_current()

            if not menu then
              return
            end

            menu:close()
          end,
        },
      },
      sources = {
        terminal = {
          name = function(buf)
            local name = vim.api.nvim_buf_get_name(buf)

            local term =
              select(2, require("toggleterm.terminal").indentify(name))

            if term then
              return term.display_name or term.name
            else
              return name
            end
          end,
        },
      },
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

    enabled = vim.fn.has("NVIM-0.10") == 1,

    event = "User NormalFile",

    opts = {
      excluded_filetypes = { "neo-tree" },
    },
  },
  {
    -- Statuscolumn added by NVIM-0.9
    "luukvbaal/statuscol.nvim",

    lazy = true,

    branch = vim.fn.has("NVIM-0.10") == 1 and "0.10" or nil,

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
              namespace = { "gitsigns_extmark_signs_" },
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

    main = "ibl",

    event = { "BufReadPre", "BufNewFile" },

    dependencies = {
      "TheGLander/indent-rainbowline.nvim",
    },

    opts = function()
      local hooks = require("ibl.hooks")

      hooks.register(
        hooks.type.WHITESPACE,
        hooks.builtin.hide_first_space_indent_level
      )

      hooks.register(
        hooks.type.SCOPE_HIGHLIGHT,
        hooks.builtin.scope_highlight_from_extmark
      )

      local new_opts = require("indent-rainbowline").make_opts({
        -- Put safe config that doesn't affect highlighting here
        indent = {
          char = "▏",
        },
        whitespace = {
          remove_blankline_trail = false,
        },
      })

      new_opts.scope.highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
      }

      return new_opts
    end,
  },
  {
    "folke/which-key.nvim",

    event = "VeryLazy",

    opts = {},
  },
  {
    "jonahgoldwastaken/copilot-status.nvim",

    lazy = true,

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
}
