local keymap = require("utils.keymap").keymap

return {
  {
    "folke/lazy.nvim",

    init = function()
      keymap("n", "<leader>L", "<cmd>Lazy<cr>", "Open lazy.nvim")
    end,
  },
  {
    "dstein64/vim-startuptime",

    cmd = { "StartupTime" },
  },
}
