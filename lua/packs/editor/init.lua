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
              "NeogitStatus",
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
  {
    "lewis6991/fileline.nvim",

    lazy = true,
  },
  {
    "ethanholz/nvim-lastplace",

    opts = {},
  },
  {
    "VidocqH/auto-indent.nvim",

    opts = {},
  },
  {
    "chrisgrieser/nvim-puppeteer",
  },
  {
    "willothy/flatten.nvim",

    priority = 1001,

    dependencies = {
      {
        "willothy/wezterm.nvim",

        cmd = "WeztermSpawn",
      },
      "toggleterm.nvim",
    },

    opts = function()
      ---@type Terminal?
      local saved_terminal

      return {
        window = {
          open = "alternate",
        },
        callbacks = {
          should_block = function(argv)
            -- Note that argv contains all the parts of the CLI command, including
            -- Neovim's path, commands, options and files.
            -- See: :help v:argv

            -- In this case, we would block if we find the `-b` flag
            -- This allows you to use `nvim -b file1` instead of
            -- `nvim --cmd 'let g:flatten_wait=1' file1`
            return vim.tbl_contains(argv, "-b")

            -- Alternatively, we can block if we find the diff-mode option
            -- return vim.tbl_contains(argv, "-d")
          end,
          pre_open = function()
            local term = require("toggleterm.terminal")
            local termid = term.get_focused_id()
            saved_terminal = term.get(termid)
          end,
          post_open = function(bufnr, winnr, ft, is_blocking)
            if is_blocking and saved_terminal then
              -- Hide the terminal while it's blocking
              saved_terminal:close()
            else
              -- If it's a normal file, just switch to its window
              vim.api.nvim_set_current_win(winnr)

              -- If we're in a different wezterm pane/tab, switch to the current one
              -- Requires willothy/wezterm.nvim
              require("wezterm").switch_pane.id(
                tonumber(os.getenv("WEZTERM_PANE"))
              )
            end

            -- If the file is a git commit, create one-shot autocmd to delete its buffer on write
            -- If you just want the toggleable terminal integration, ignore this bit
            if ft == "gitcommit" or ft == "gitrebase" then
              vim.api.nvim_create_autocmd("BufWritePost", {
                buffer = bufnr,
                once = true,
                callback = vim.schedule_wrap(function()
                  vim.api.nvim_buf_delete(bufnr, {})
                end),
              })
            end
          end,
          block_end = function()
            -- After blocking ends (for a git commit, etc), reopen the terminal
            vim.schedule(function()
              if saved_terminal then
                saved_terminal:open()
                saved_terminal = nil
              end
            end)
          end,
        },
      }
    end,
  },
}
