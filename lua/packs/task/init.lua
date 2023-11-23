return {
  "stevearc/overseer.nvim",

  cmd = {
    "OverseerOpen",
    "OverseerToggle",
    "OverseerLoadBundle",
    "OverseerDeleteBundle",
    "OverseerRunCmd",
    "OverseerRun",
    "OverseerInfo",
    "OverseerBuild",
    "OverseerQuickAction",
    "OverseerTaskAction",
    "OverseerClearCache",
  },

  init = function()
    local keymap = require("utils.keymap").keymap

    keymap("n", "<leader>tt", "<cmd>OverseerToggle<cr>", "Toggle Task Runner")
    keymap("n", "<leader>tr", "<cmd>OverseerRun<cr>", "Run Task")
  end,

  opts = function()
    require("dap.ext.vscode").json_decode = require("overseer.json").decode

    return {
      strategy = {
        "toggleterm",
        quit_on_exit = "success",
      },
    }
  end,

  dependencies = {
    "nvim-dap",
  },
}
