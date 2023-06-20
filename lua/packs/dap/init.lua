return {
  {
    {
      {
        "mfussenegger/nvim-dap",

        lazy = true,

        config = function()
          require("mason-nvim-dap")
          require("dapui")
          require("nvim-dap-virtual-text")
        end,

        dependencies = {
          {
            "rcarriga/nvim-dap-ui",

            opts = {},
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
                },
              }
            end,
          },
        },
      },
    },
  },
}
