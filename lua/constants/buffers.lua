local M = {}

local quit_with_q = {
  buftypes = {
    "quickfix",
  },
  filetypes = {
    -- Code from LazyVim
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",

    -- vim-dadbod
    "dbout",
  },
}

local ignore_buf_change_filetypes = vim.tbl_extend("force", quit_with_q, {
  -- alpha-nvim
  "alpha",

  -- nvim-dap
  "dbui",

  -- neo-tree.nvim
  "neo-tree",

  -- quickfix
  "qf",
})

M.window = {
  quit_with_q = quit_with_q,
  ignore_buf_change_filetypes = ignore_buf_change_filetypes,
}

return M
