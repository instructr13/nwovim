return {
  {
    "kwkarlwang/bufresize.nvim",

    lazy = true,

    event = { "VimResized" },

    opts = {},
  },
  {
    "mrjones2014/smart-splits.nvim",

    config = function()
      require("smart-splits").setup({
        resize_mode = {
          hooks = {
            on_leave = require("bufresize").register,
          },
        },
      })

      local keymap = require("utils.keymap").omit("insert", "n", "<^%>")

      keymap("A-h", function()
        require("smart-splits").resize_left()
      end)
      keymap("A-j", function()
        require("smart-splits").resize_down()
      end)
      keymap("A-k", function()
        require("smart-splits").resize_up()
      end)
      keymap("A-l", function()
        require("smart-splits").resize_right()
      end)

      keymap("C-h", function()
        require("smart-splits").move_cursor_left()
      end)
      keymap("C-j", function()
        require("smart-splits").move_cursor_down()
      end)
      keymap("C-k", function()
        require("smart-splits").move_cursor_up()
      end)
      keymap("C-l", function()
        require("smart-splits").move_cursor_right()
      end)

      keymap("<leader><leader>h", function()
        require("smart-splits").swap_buf_left()
      end)
      keymap("<leader><leader>j", function()
        require("smart-splits").swap_buf_down()
      end)
      keymap("<leader><leader>k", function()
        require("smart-splits").swap_buf_up()
      end)
      keymap("<leader><leader>l", function()
        require("smart-splits").swap_buf_right()
      end)
    end,
  },
}
