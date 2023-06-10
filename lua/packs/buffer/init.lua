local keymap = require("utils.keymap").keymap

return {
  {
    "tiagovla/scope.nvim",

    opts = { restore_state = true }
  },
  {
    "echasnovski/mini.bufremove",

    lazy = true,

    init = function()
      keymap("n", "<leader>q", function()
        require("mini.bufremove").delete()
      end, "Close buffer")
    end
  }
}
