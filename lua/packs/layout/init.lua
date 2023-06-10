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
          "MunifTanjim/nui.nvim"
        },

        branch = "v2.x",

        init = function()
          vim.g.neo_tree_remove_legacy_commands = 1
        end,

        opts = {
          window = {
            mappings = {
              ["e"] = function()
                vim.api.nvim_exec([[Neotree focus filesystem left]], true)
              end,
              ["b"] = function()
                vim.api.nvim_exec([[Neotree focus buffers left]], true)
              end,
              ["g"] = function()
                vim.api.nvim_exec([[Neotree focus git_status left]], true)
              end,
            }
          },

          filesystem = {
            window = {
              mappings = {
                ["<tab>"] = function(state)
                  local node = state.tree:get_node()

                  if require("neo-tree.utils").is_expandable(node) then
                    state.commands["toggle_node"](state)
                  else
                    state.commands["open"](state)

                    vim.cmd [[Neotree reveal]]
                  end
                end,
                ["h"] = function(state)
                  local node = state.tree:get_node()

                  if node.type == 'directory' and node:is_expanded() then
                    require("neo-tree.sources.filesystem").toggle_directory(state, node)
                  else
                    require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
                  end
                end,
                ["l"] = function(state)
                  local node = state.tree:get_node()

                  if node.type == 'directory' then
                    if not node:is_expanded() then
                      require("neo-tree.sources.filesystem").toggle_directory(state, node)
                    elseif node:has_children() then
                      require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
                    end
                  end
                end,
              }
            },
          },

          source_selector = {
            winbar = true
          }
        }
      }
    },

    opts = {
      bottom = {
        {
          ft = "toggleterm",
          size = {
            height = 0.4
          },
          -- exclude floating windows
          filter = function(_, win)
            return vim.api.nvim_win_get_config(win).relative == ""
          end
        },
        "Trouble",
        { ft = "qf",          title = "QuickFix" },
        { ft = "startuptime", title = "Startup Time Measurement" },
        {
          ft = "help",
          size = { height = 20 },
          -- only show help buffers
          filter = function(buf)
            return vim.bo[buf].buftype == "help"
          end,
        },
      }
    },
  }
}
