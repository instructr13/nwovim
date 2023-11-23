local Path = require("plenary.path")

local C = require("packs.dap.config")

return {
  {
    {
      {
        "mfussenegger/nvim-dap",

        lazy = true,

        init = function()
          C.dap_setup()
        end,

        config = function()
          C.dap()
        end,

        dependencies = {
          {
            "rcarriga/nvim-dap-ui",

            opts = {
              floating = {
                border = "rounded",
              },
            },
          },
          {
            "theHamsta/nvim-dap-virtual-text",

            opts = {},
          },
          {
            "jay-babu/mason-nvim-dap.nvim",

            lazy = true,

            dependencies = {
              "mason.nvim",
            },

            opts = function()
              return {
                handlers = {
                  function(config)
                    require("mason-nvim-dap").default_setup(config)
                  end,
                  python = function(config)
                    config.adapters = {
                      type = "executable",
                      command = "python",
                      args = { "-m", "debugpy.adapter" },
                    }

                    require("mason-nvim-dap").default_setup(config)
                  end,
                },
              }
            end,
          },
        },
      },
    },
  },
}
