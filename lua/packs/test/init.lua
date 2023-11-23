return {
  {
    "nvim-neotest/neotest",

    cmd = { "Neotest" },

    dependencies = {
      "plenary.nvim",
      "nvim-neotest/neotest-python",
      "nvim-neotest/neotest-go",
      "marilari88/neotest-vitest",
      "thenbe/neotest-playwright",
      "sidlatau/neotest-dart",
      "rouge8/neotest-rust",
      "Issafalcon/neotest-dotnet",
      "MarkEmmons/neotest-deno",
      "rcasia/neotest-java",
    },

    opts = function()
      local Path = require("plenary.path")

      return {
        adapters = {
          require("neotest-python")({
            python = function()
              local venv_python_path = Path:new(vim.env.VIRTUAL_ENV or ".venv")
                :joinpath("bin", "python")

              if venv_python_path:is_file() then
                return venv_python_path:normalize()
              end
            end,
          }),
          require("neotest-go"),
          require("neotest-vitest"),
          require("neotest-playwright").adapter({
            options = {
              persist_project_selection = true,
              enable_dynamic_test_discovery = true,
            },
          }),
          require("neotest-dart")({
            use_lsp = true,
          }),
          require("neotest-rust")({
            args = { "--no-capture" },
            dap_adapter = "lldb",
          }),
          require("neotest-dotnet"),
          require("neotest-deno"),
          require("neotest-java"),
        },
        consumers = {
          overseer = require("neotest.consumers.overseer"),
        },
        overseer = {
          enabled = true,
        },
      }
    end,
  },
}
