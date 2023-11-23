return {
  "stevearc/resession.nvim",

  lazy = true,

  init = function()
    local keymap = require("utils.keymap.presets").leader("n", "s")

    keymap("s", function()
      require("resession").save_tab()
    end, "Save Session")

    keymap("l", function()
      require("resession").load()
    end, "Load Session")

    keymap("d", function()
      require("resession").delete()
    end, "Delete Session")

    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        require("resession").save("last")
      end,
    })
  end,

  opts = {
    tab_buf_filter = function(tabpage, bufnr)
      local dir = vim.fn.getcwd(-1, vim.api.nvim_tabpage_get_number(tabpage))

      return vim.startswith(vim.api.nvim_buf_get_name(bufnr), dir)
    end,
    extensions = {
      overseer = {},
    },
  },
}
