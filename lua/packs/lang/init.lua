local C = require("packs.lang.config")

local join_paths = require("utils.paths").join_paths

return {
  -- Lua
  {
    "folke/neodev.nvim",

    lazy = true,
  },
  -- Java
  {
    "mfussenegger/nvim-jdtls",

    lazy = true,

    init = function()
      C.jdtls_setup()
    end,

    dependencies = {
      "mason.nvim",
    },
  },
  -- Rust
  {
    "simrat39/rust-tools.nvim",

    lazy = true,

    dependencies = {
      "mason.nvim",
    },

    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup(
          "rust_tools_config",
          { clear = true }
        ),
        pattern = "rust",
        desc = "Setup rust-tools",
        callback = function()
          require("rust-tools") -- Load

          vim.schedule(function()
            vim.cmd("LspStart rust-analyzer")
          end)
        end,
      })
    end,

    opts = function()
      local rust_tools = require("rust-tools")

      local extension_path = join_paths(
        require("mason-registry").get_package("codelldb"):get_install_path(),
        "extension"
      )

      local codelldb_path = join_paths(extension_path, "adapter", "codelldb")

      local liblldb_path =
        join_paths(extension_path, "lldb", "lib", "liblldb.so")

      return {
        dap = {
          adapter = require("rust-tools.dap").get_codelldb_adapter(
            codelldb_path,
            liblldb_path
          ),
        },
        server = {
          on_attach = function(client, buffer)
            -- Hover actions
            vim.keymap.set(
              "n",
              "gK",
              rust_tools.hover_actions.hover_actions,
              { buffer = buffer }
            )

            -- Code action groups
            vim.keymap.set(
              "n",
              "<F5>",
              rust_tools.code_action_group.code_action_group,
              { buffer = buffer }
            )

            require("lsp.on_attach")(client, buffer)
          end,
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                command = "clippy",
              },
            },
          },
        },
        tools = {
          hover_actions = {
            auto_focus = true,
          },
          inlay_hints = {
            auto = false,
          },
        },
      }
    end,
  },
  -- Markdown
  {
    "atusy/tsnode-marker.nvim",

    lazy = true,

    init = function()
      C.tsnode_marker_setup()
    end,
  },
  {
    "lukas-reineke/headlines.nvim",

    ft = { "markdown", "norg" },

    dependencies = "nvim-treesitter/nvim-treesitter",

    opts = {},
  },
}
