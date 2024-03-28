local Path = require("plenary.path")

local C = require("packs.lang.config")

local is_windows = require("utils.os").is_windows
local is_linux = require("utils.os").is_linux
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
        pattern = "javascript,javascriptreact,typescript,typescriptreact",
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
    "mrcjkb/rustaceanvim",

    ft = "rust",

    dependencies = {
      "mason.nvim",
    },

    init = function()
      vim.g.rustaceanvim = function()
        local extension_path = Path:new(
          require("mason-registry").get_package("codelldb"):get_install_path(),
          "extension"
        )

        local codelldb_path = extension_path:joinpath("adapter", "codelldb")

        local liblldb_path = extension_path:joinpath("lldb", "lib", "liblldb")

        if is_windows then
          codelldb_path = Path:new(tostring(codelldb_path) .. ".exe")
          liblldb_path = Path:new(tostring(liblldb_path) .. ".dll")
        else
          liblldb_path =
            Path:new(tostring(liblldb_path) .. (is_linux and ".so" or ".dylib"))
        end

        local cfg = require("rustaceanvim.config")

        return {
          dap = {
            adapter = cfg.get_codelldb_adapter(
              tostring(codelldb_path),
              tostring(liblldb_path)
            ),
          },
          server = {
            on_attach = function(client, buffer)
              -- Hover actions
              keymap(
                "n",
                "<F5>",
                require("rustaceanvim.commands.debuggables").debuggables,
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
            tools = {
              executor = require("rustaceanvim.executors").toggleterm,
            },
          },
        }
      end
    end,
  },
  -- Flutter
  {
    "akinsho/flutter-tools.nvim",

    ft = { "dart" },

    init = function()
      require("utils.telescope").register_extension("flutter")
    end,

    opts = {
      flutter_path = vim.env.FLUTTER_ROOT
          and Path:new(vim.env.FLUTTER_ROOT, "bin", "flutter"):absolute()
        or nil,
      debugger = {
        enabled = true,
      },
      widget_guides = {
        enabled = true,
      },
      lsp = {
        on_attach = require("lsp.on_attach"),
        capabilities = require("lsp.capabilities").make_capabilities(),
        color = {
          enabled = true,
        },
      },
    },
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
  {
    "jmederosalvarado/roslyn.nvim",

    enabled = vim.fn.has("NVIM-0.10") == 1,

    ft = { "cs", "fsharp" },

    opts = function()
      return {
        on_attach = require("lsp.on_attach"),
        capabilities = require("lsp.capabilities").make_capabilities(),
      }
    end,
  },
  {
    "edKotinsky/Arduino.nvim",

    commit = "38559b1",

    ft = "arduino",

    dependencies = {
      "mason.nvim",
    },

    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "ArduinoFqbnReset",
        callback = function()
          vim.cmd.LspRestart("arduino_language_server")
        end,
      })
    end,

    opts = function()
      return {
        clangd = require("mason-core.path").bin_prefix("clangd"),
      }
    end,
  },
  {
    "lervag/vimtex",

    ft = "tex",

    init = function()
      vim.g.vimtex_syntax_enabled = 0
      vim.g.vimtex_syntax_conceal_disable = 1
    end,
  },
}
