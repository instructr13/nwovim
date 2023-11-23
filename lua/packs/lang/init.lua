local Path = require("plenary.path")

local C = require("packs.lang.config")

local join_paths = require("utils.paths").join_paths
local keymap = require("utils.keymap").keymap

return {
  -- Lua
  {
    "folke/neodev.nvim",

    lazy = true,
  },
  -- JS / TS (Deno)
  {
    "sigmaSd/deno-nvim",

    lazy = true,

    init = function()
      local deno = require("lsp.special.denols")

      local group = vim.api.nvim_create_augroup("deno_config", { clear = true })

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = "typescript",
        desc = "Setup deno or tsserver",
        callback = function(args)
          local bufnr = args.buf

          deno.refresh(bufnr)

          local enable_deno = vim.b[bufnr].lsp_enable_deno
          local client_name = enable_deno and "denols" or "tsserver"
          local client = require("utils.lsp").find_client(client_name)

          if enable_deno then
            require("deno-nvim") -- Load
          end

          if client then
            vim.lsp.buf_attach_client(bufnr, client.id)

            return
          end

          require("lspconfig.configs")[client_name].launch()
        end,
      })
    end,

    opts = function()
      local js_debug_path = Path:new(
        require("mason-registry")
          .get_package("js-debug-adapter")
          :get_install_path()
      )

      local new_opts = {
        server = {
          autostart = false,
          on_attach = require("lsp.on_attach"),
          capabilities = require("lsp.capabilities").make_capabilities(),
          settings = {
            codeLens = {
              implementations = true,
              references = true,
            },
          },
        },
      }

      if js_debug_path:is_dir() then
        new_opts.dap = {
          adapter = {
            executable = {
              args = {
                js_debug_path
                  :joinpath("js-debug", "src", "dapDebugServer.js")
                  :absolute(),
                "${port}",
              },
            },
          },
        }

        require("dap").configurations.typescript = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            runtimeExecutable = "deno",
            runtimeArgs = {
              "run",
              "--inspect-wait",
              "--allow-all",
            },
            program = "${file}",
            cwd = "${workspaceFolder}",
            attachSimplePort = 9229,
          },
        }
      end

      return new_opts
    end,

    dependencies = {
      "nvim-dap",
    },
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
        once = true,
        callback = function()
          require("rust-tools") -- Load

          vim.schedule(function()
            vim.cmd("LspStart rust-analyzer")
          end)
        end,
      })
    end,

    opts = function()
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
            keymap(
              "n",
              "<F5>",
              require("rust-tools").debuggables.debuggables,
              "Debugger: Start",
              { buffer = buffer }
            )

            require("lsp.on_attach")(client, buffer)
          end,
          capabilities = require("lsp.capabilities").make_capabilities(),
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                command = "clippy",
              },
            },
          },
        },
        tools = {
          executor = require("rust-tools.executors").toggleterm,
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
  -- Flutter
  {
    "akinsho/flutter-tools.nvim",

    ft = { "dart" },

    opts = function()
      return {
        debugger = {
          enabled = true,
        },
        lsp = {
          on_attach = require("lsp.on_attach"),
          capabilities = require("lsp.capabilities").make_capabilities(),
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
