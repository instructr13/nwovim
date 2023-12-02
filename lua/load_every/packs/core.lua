local keymap = require("utils.keymap").keymap

return {
  {
    "folke/lazy.nvim",

    version = "*",

    init = function()
      keymap("n", "<leader>L", "<cmd>Lazy<cr>", "Open lazy.nvim")
    end,
  },
  {
    "vim-denops/denops.vim",

    lazy = true,

    enabled = vim.fn.executable("deno") == 1,
  },
}
