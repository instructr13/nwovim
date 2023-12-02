local keymap = require("utils.keymap").keymap

return {
  {
    "nvim-telescope/telescope.nvim",

    cmd = { "Telescope" },

    dependencies = {
      "plenary.nvim",
    },

    init = function()
      local keymap =
        require("utils.keymap.presets").leader("n", "f", { noremap = true })

      keymap("f", "<cmd>Telescope find_files<cr>", "Find files")
      keymap("g", "<cmd>Telescope live_grep<cr>", "Live Grep")
      keymap("b", "<cmd>Telescope buffers<cr>", "Buffers")
      keymap("h", "<cmd>Telescope oldfiles<cr>", "Find recently opened files")
      keymap("t", "<cmd>Telescope treesitter<cr>", "Treesitter")
      keymap("c", "<cmd>Telescope commands<cr>", "Commands")
      keymap("m", "<cmd>Telescope marks<cr>", "Marks")
      keymap("q", "<cmd>Telescope quickfix<cr>", "Quickfix")
    end,

    opts = function()
      require("utils.telescope").load_registered_extensions()

      local actions = require("telescope.actions")
      local actions_layout = require("telescope.actions.layout")

      return {
        defaults = {
          winblend = 10,
          path_display = {
            shorten = {
              len = 1,
              exclude = { 3, 4, -1 },
            },
          },
          dynamic_preview_title = true,
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-o>"] = actions.select_vertical,
              ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
              ["<C-l>"] = actions_layout.toggle_preview,
              ["<C-d>"] = actions.preview_scrolling_up,
              ["<C-f>"] = actions.preview_scrolling_down,
              ["<C-n>"] = actions.cycle_history_next,
              ["<C-u>"] = actions.cycle_history_prev,
              ["<Esc>"] = actions.close,
              ["<cr>"] = actions.select_default + actions.center,
            },
          },
        },
        extensions = {
          -- Sorter
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      }
    end,
  },
  {
    "nvim-telescope/telescope-frecency.nvim",

    lazy = true,

    init = function()
      require("utils.telescope").register_extension("frecency")

      local keymap =
        require("utils.keymap.presets").leader("n", "f", { noremap = true })

      keymap("r", "<cmd>Telescope frecency<cr>", "Most frequently used files")
    end,
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",

    lazy = true,

    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
  },
  {
    "nvim-pack/nvim-spectre",

    lazy = true,

    init = function()
      local keymap = require("utils.keymap").omit("append", "n", "<leader>")

      keymap("S", function()
        require("spectre").open()
      end, "Open Spectre")

      keymap("sw", function()
        require("spectre").open_visual({ select_word = true })
      end, "Search current word")

      require("utils.keymap").keymap("v", "<leader>sw", function()
        require("spectre").open_visual()
      end, "Search selected word")

      keymap("sp", function()
        require("spectre").open_file_search({ select_word = true })
      end, "Search on current file")
    end,
  },
  {
    "cshuaimin/ssr.nvim",

    lazy = true,

    init = function()
      keymap("n", "<leader>sr", function()
        require("ssr").open()
      end, "Structual search")
    end,

    opts = {
      border = "rounded",
      min_width = 50,
      min_height = 5,
      max_width = 120,
      max_height = 25,
      adjust_window = true,
      keymaps = {
        close = "q",
        next_match = "n",
        prev_match = "N",
        replace_confirm = "<cr>",
        replace_all = "<leader><cr>",
      },
    },
  },
}
