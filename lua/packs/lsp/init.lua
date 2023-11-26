local data_dir = require("constants.paths").data_dir
local join_paths = require("utils.paths").join_paths

return {
  {
    "williamboman/mason.nvim",

    lazy = true,

    cmd = "Mason",

    build = ":MasonUpdate",

    opts = function()
      require("mason-registry"):on(
        "package:install:success",
        vim.schedule_wrap(function(pkg)
          if pkg.name == "jdtls" then
            local base_path = join_paths(
              data_dir,
              "nwovim",
              "packages",
              "vscode-java-decompiler"
            )

            vim.notify("Installing vscode-java-decompiler used by jdtls")

            vim.system({
              "git",
              "clone",
              "--depth=1",
              "https://github.com/dgileadi/vscode-java-decompiler",
              base_path,
            }, { stdout = false }, function(obj)
              if obj.code == 0 and obj.signal == 0 then
                vim.notify("vscode-java-decompiler installed successfully")
              end
            end)
          end
        end)
      )

      return {
        ui = {
          border = "rounded",
        },
      }
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",

    event = { "BufReadPost", "BufNewFile" },

    opts = function()
      local handlers = require("lsp.handlers")

      require("neoconf")

      return {
        ensure_installed = { "lua_ls", "jsonls" },
        handlers = handlers,
      }
    end,

    dependencies = {
      "williamboman/mason.nvim",
      {
        "neovim/nvim-lspconfig",

        config = function()
          require("lspconfig.ui.windows").default_options.border = "rounded"
        end,
      },
      "b0o/SchemaStore.nvim",
    },
  },
  {
    "jay-babu/mason-null-ls.nvim",

    event = { "User NormalFile" },

    opts = function()
      local function exclude_formatting(methods)
        return vim.tbl_filter(function(method)
          -- Formatting is done by conform.nvim
          return method ~= "formatting"
        end, methods)
      end

      return {
        handlers = {
          function(source_name, methods)
            require("mason-null-ls.automatic_setup")(
              source_name,
              exclude_formatting(methods)
            )
          end,
          eslint_d = function(source_name, methods)
            require("utils.null-ls").register_with(
              source_name,
              exclude_formatting(methods),
              {
                condition = function(params)
                  return require("lsp.special.eslint_d").has_config(
                    params.bufnr
                  )
                end,
                env = function(params)
                  local type = require("lsp.special.eslint_d").get_config_type(
                    params.bufnr
                  )

                  if type == "flat" then
                    return {
                      ESLINT_USE_FLAT_CONFIG = "true",
                    }
                  end

                  return {}
                end,
              }
            )
          end,
        },
      }
    end,

    dependencies = {
      "williamboman/mason.nvim",

      {
        "nvimtools/none-ls.nvim",

        opts = function()
          local builtins = require("null-ls").builtins

          return {
            border = "rounded",
            update_in_insert = false,
            sources = {
              builtins.code_actions.gitsigns,
              builtins.code_actions.gitrebase,
              builtins.code_actions.impl, -- Go
              builtins.code_actions.refactoring,
              builtins.hover.dictionary,
              builtins.hover.printenv,
            },
          }
        end,
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",

    event = { "User NormalFile" },

    opts = {
      ensure_installed = { "stylua", "prettierd" },
    },
  },
  {
    "KostkaBrukowa/definition-or-references.nvim",

    lazy = true,

    opts = {
      on_references_result = function()
        vim.cmd("Trouble lsp_references")
      end,
    },
  },
  {
    "seblj/nvim-lsp-extras",

    event = { "User NormalFile" },

    opts = {
      signature = false,
    },
  },
  {
    "Wansmer/symbol-usage.nvim",

    event = { "LspAttach" },

    opts = function()
      local function h(name)
        return vim.api.nvim_get_hl(0, { name = name })
      end

      vim.api.nvim_set_hl(
        0,
        "SymbolUsageRounding",
        { fg = h("CursorLine").bg, italic = true }
      )
      vim.api.nvim_set_hl(
        0,
        "SymbolUsageContent",
        { bg = h("CursorLine").bg, fg = h("Comment").fg, italic = true }
      )
      vim.api.nvim_set_hl(
        0,
        "SymbolUsageRef",
        { fg = h("Function").fg, bg = h("CursorLine").bg, italic = true }
      )
      vim.api.nvim_set_hl(
        0,
        "SymbolUsageDef",
        { fg = h("Type").fg, bg = h("CursorLine").bg, italic = true }
      )
      vim.api.nvim_set_hl(
        0,
        "SymbolUsageImpl",
        { fg = h("@keyword").fg, bg = h("CursorLine").bg, italic = true }
      )

      return {
        vt_position = "textwidth",
        implementation = { enable = true },
        text_format = function(symbol)
          local result = {}

          local round_start = { "", "SymbolUsageRounding" }
          local round_end = { "", "SymbolUsageRounding" }

          if symbol.references then
            local usage = symbol.references <= 1 and "usage" or "usages"
            local num = symbol.references == 0 and "no" or symbol.references

            table.insert(result, round_start)
            table.insert(result, { "󰌹 ", "SymbolUsageRef" })
            table.insert(
              result,
              { ("%s %s"):format(num, usage), "SymbolUsageContent" }
            )
            table.insert(result, round_end)
          end

          if symbol.definition then
            if #result > 0 then
              table.insert(result, { " ", "NonText" })
            end

            table.insert(result, round_start)
            table.insert(result, { "󰳽 ", "SymbolUsageDef" })
            table.insert(
              result,
              { symbol.definition .. " defs", "SymbolUsageContent" }
            )
            table.insert(result, round_end)
          end

          if symbol.implementation then
            if #result > 0 then
              table.insert(result, { " ", "NonText" })
            end

            table.insert(result, round_start)
            table.insert(result, { "󰡱 ", "SymbolUsageImpl" })
            table.insert(
              result,
              { symbol.implementation .. " impls", "SymbolUsageContent" }
            )
            table.insert(result, round_end)
          end

          return result
        end,
      }
    end,
  },
  {
    "stevearc/conform.nvim",

    event = { "BufWritePre" },

    cmd = { "ConformInfo" },

    keys = {
      {
        "<F3>",
        function()
          require("conform").format({ async = true, lsp_fallback = true })
        end,
        mode = { "n", "i" },
        desc = "Format current buffer",
      },
    },

    init = function()
      vim.opt.formatexpr = "v:lua.require('conform').formatexpr()"

      vim.api.nvim_create_user_command("Format", function(args)
        local range = nil

        if args.count ~= -1 then
          local end_line =
            vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
          range = {
            start = { args.line1, 0 },
            ["end"] = { args.line2, end_line:len() },
          }
        end

        require("conform").format({
          async = true,
          lsp_fallback = true,
          range = range,
        })
      end, { range = true })

      vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
          -- FormatDisable! will disable formatting just for this buffer
          vim.b.disable_autoformat = true
        else
          vim.g.disable_autoformat = true
        end
      end, {
        desc = "Disable autoformat-on-save",
        bang = true,
      })

      vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
      end, {
        desc = "Re-enable autoformat-on-save",
      })

      vim.api.nvim_create_user_command("FormatToggle", function(args)
        if args.bang then
          vim.b.disable_autoformat = not vim.b.disable_autoformat
        else
          vim.g.disable_autoformat = not vim.g.disable_autoformat
        end
      end, {
        desc = "Toggle autoformat-on-save",
        bang = true,
      })
    end,

    opts = function()
      local conform = require("conform")
      local root_file = require("conform.util").root_file

      require("conform.formatters").eslint_d.condition = function(ctx)
        return require("lsp.special.eslint_d").has_config(ctx.buf)
      end

      local function get_ctx(formatter, bufnr)
        if not bufnr or bufnr == 0 then
          bufnr = vim.api.nvim_get_current_buf()
        end

        local config = conform.get_formatter_config(formatter, bufnr)

        return require("conform.runner").build_context(bufnr, config)
      end

      local other_deno_formatters = function(bufnr)
        return vim.b[bufnr].lsp_enable_deno and { "deno_fmt" }
          or { { "prettierd", "prettier" } }
      end

      local js_formatters = function(bufnr)
        local formatters = other_deno_formatters(bufnr)

        local eslint = conform.get_formatter_info("eslint_d", bufnr)
        local type = require("lsp.special.eslint_d").get_config_type(bufnr)

        if eslint.available and type then
          if type == "flat" then
            require("conform.formatters").eslint_d.env =
              { ESLINT_USE_FLAT_CONFIG = "true" }
          else
            require("conform.formatters").eslint_d.env = {}
          end

          --[[require("conform.formatters").eslint_d.cwd = function(ctx)
            local flat_config_root = root_file({
              "eslint.config.js",
            })(ctx)

            if flat_config_root then
              return flat_config_root
            end

            return root_file({
              ".eslintrc.js",
              ".eslintrc.cjs",
              ".eslintrc.json",
              ".eslintrc.yml",
              ".eslintrc.yaml",
              "package.json",
            })(ctx)
          end]]
        end

        table.insert(formatters, 1, "eslint_d")

        local rustywind_cwd = root_file({
          "tailwind.config.js",
          "tailwind.config.cjs",
        })(get_ctx("rustywind", bufnr))

        if rustywind_cwd then
          table.insert(formatters, "rustywind")
        end

        return formatters
      end

      local slow_format_filetypes = {}

      return {
        formatters_by_ft = {
          astro = { "prettierd", "prettier" },
          bash = { "shfmt" },
          sh = { "shfmt" },
          fish = { "fish_indent" },
          proto = { "buf" },
          c = { "clang_format" },
          cpp = { "clang_format" },
          lua = { "stylua" },
          go = { "goimports", "gofmt" },
          dart = { "dart_format" },
          tex = { "latexindent" },
          python = function(bufnr)
            if conform.get_formatter_info("ruff_format", bufnr).available then
              return { "ruff_format" }
            else
              return { "isort", "black" }
            end
          end,
          javascript = js_formatters,
          typescript = js_formatters,
          javascriptreact = js_formatters,
          typescriptreact = js_formatters,
          vue = { { "prettierd", "prettier" } },
          css = { { "prettierd", "prettier" } },
          scss = { { "prettierd", "prettier" } },
          less = { { "prettierd", "prettier" } },
          html = { { "prettierd", "prettier" } },
          json = other_deno_formatters,
          jsonc = other_deno_formatters,
          yaml = { { "prettierd", "prettier" } },
          markdown = other_deno_formatters,
          ["markdown.mdx"] = { { "prettierd", "prettier" } },
          graphql = { { "prettierd", "prettier" } },
          handlebars = { { "prettierd", "prettier" } },
          rust = { "rustfmt" },
          toml = { "taplo" },
          terraform = { "terraform_fmt" },

          ["_"] = { "trim_whitespace" },
        },
        format_on_save = function(bufnr)
          if
            slow_format_filetypes[vim.bo[bufnr].filetype]
            or vim.g.disable_autoformat
            or vim.b[bufnr].disable_autoformat
          then
            return
          end

          local bufname = vim.api.nvim_buf_get_name(bufnr)

          if bufname:match("/node_modules/") then
            return
          end

          local function on_format(err)
            if err and err:match("timeout$") then
              slow_format_filetypes[vim.bo[bufnr].filetype] = true
            end
          end

          return {
            timeout_ms = 200,
            lsp_fallback = true,
          },
            on_format
        end,
        format_after_save = function(bufnr)
          if not slow_format_filetypes[vim.bo[bufnr].filetype] then
            return
          end

          return { lsp_fallback = true }
        end,
      }
    end,
  },
  {
    "j-hui/fidget.nvim",

    event = { "LspAttach" },

    dependencies = { "nvim-tree/nvim-web-devicons" },

    opts = {
      progress = {
        ignore_done_already = true,
        ignore = { "null-ls" },
      },
    },
  },
  {
    "folke/trouble.nvim",

    cmd = { "Trouble" },

    dependencies = { "nvim-tree/nvim-web-devicons" },

    opts = {
      use_diagnostic_signs = true,
    },
  },
  {
    "folke/neoconf.nvim",

    lazy = true,

    opts = {},
  },
  {
    "hinell/lsp-timeout.nvim",

    event = { "LspAttach" },

    init = function()
      vim.g.lspTimeoutConfig = {
        stopTimeout = 1000 * 60 * 10,
        startTimeout = 0,
      }
    end,
  },
  {
    "luckasRanarison/clear-action.nvim",

    event = { "LspAttach" },

    opts = {
      signs = {
        enable = false,
      },
      mappings = {
        code_action = "<F4>",
      },
    },
  },
}
