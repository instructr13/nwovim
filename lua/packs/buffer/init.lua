local keymap = require("utils.keymap").keymap

return {
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
