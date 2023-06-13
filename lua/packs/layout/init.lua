local C = require("packs.layout.config")

return {
  {
    "folke/edgy.nvim",

    event = "VeryLazy",

    dependencies = {
      {
        "nvim-neo-tree/neo-tree.nvim",

        cmd = "Neotree",

        dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-tree/nvim-web-devicons",
          "MunifTanjim/nui.nvim",
        },

        branch = "v2.x",

        init = function()
          vim.g.neo_tree_remove_legacy_commands = 1

          local keymap = require("utils.keymap").keymap

          keymap("n", "\\", "<cmd>Neotree toggle<cr>", "Toggle Neo-tree")
        end,

        opts = {
          sources = {
            "filesystem",
            "buffers",
            "git_status",
            "document_symbols",
          },
          auto_clean_after_session_restore = true,
          hide_root_node = true,
          use_popups_for_input = false,

          source_selector = {
            winbar = false,

            sources = {
              { source = "filesystem" },
              { source = "git_status" },
              { source = "buffers" },
            },
          },

          event_handlers = {
            {
              event = "file_moved",
              handler = C.neo_tree.on_file_move,
            },
            {
              event = "file_renamed",
              handler = C.neo_tree.on_file_move,
            },
          },

          window = {
            mappings = {
              ["f"] = function()
                vim.api.nvim_exec([[Neotree focus filesystem left]], true)
              end,
              ["b"] = function()
                vim.api.nvim_exec([[Neotree focus buffers left]], true)
              end,
              ["g"] = function()
                vim.api.nvim_exec([[Neotree focus git_status left]], true)
              end,
            },
          },

          filesystem = {
            filtered_items = {
              hide_dotfiles = false,
              hide_by_name = {
                "node_modules",
              },
              never_show = {
                ".DS_Store",
                "thumbs.db",
              },
              never_show_by_pattern = {
                ".null-ls_*",
              },
            },
            group_empty_dirs = true,
            use_libuv_file_watcher = true,
            window = {
              mappings = {
                ["<tab>"] = function(state)
                  local node = state.tree:get_node()

                  if require("neo-tree.utils").is_expandable(node) then
                    state.commands["toggle_node"](state)
                  else
                    state.commands["open"](state)

                    vim.cmd([[Neotree reveal]])
                  end
                end,
                ["h"] = function(state)
                  local node = state.tree:get_node()

                  if node.type == "directory" and node:is_expanded() then
                    require("neo-tree.sources.filesystem").toggle_directory(
                      state,
                      node
                    )
                  else
                    require("neo-tree.ui.renderer").focus_node(
                      state,
                      node:get_parent_id()
                    )
                  end
                end,
                ["l"] = function(state)
                  local node = state.tree:get_node()

                  if node.type == "directory" then
                    if not node:is_expanded() then
                      require("neo-tree.sources.filesystem").toggle_directory(
                        state,
                        node
                      )
                    elseif node:has_children() then
                      require("neo-tree.ui.renderer").focus_node(
                        state,
                        node:get_child_ids()[1]
                      )
                    end
                  end
                end,
              },
            },
          },
        },
      },
    },

    opts = {
      exit_when_last = true,
      bottom = {
        {
          ft = "toggleterm",
          size = {
            height = 0.4,
          },
          -- exclude floating windows
          filter = function(_, win)
            return vim.api.nvim_win_get_config(win).relative == ""
          end,
        },
        "Trouble",
        { ft = "qf", title = "QuickFix" },
        { ft = "startuptime", title = "Startup Time Measurement" },
        {
          ft = "help",
          size = { height = 20 },
          -- only show help buffers
          filter = function(buf)
            return vim.bo[buf].buftype == "help"
          end,
        },
      },
      left = {
        {
          title = "Neo-tree",
          ft = "neo-tree",
          pinned = true,
          filter = function(buf)
            local source = vim.b[buf].neo_tree_source

            return source == "filesystem" or source == "remote"
          end,
        },
        {
          title = "Git",
          ft = "neo-tree",
          pinned = true,
          open = "Neotree position=top git_status",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "git_status"
          end,
        },
        {
          title = "Buffers",
          ft = "neo-tree",
          pinned = true,
          open = "Neotree position=bottom buffers",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "buffers"
          end,
        },
        {
          title = "Document Symbols",
          ft = "neo-tree",
          pinned = true,
          open = "Neotree position=right document_symbols",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "document_symbols"
          end,
        },
      },
    },
  },
}