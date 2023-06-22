local M = {}

local quit_with_q = {
  buftypes = {
    "quickfix",
  },
  filetypes = {
    -- vim-dadbod
    "dbout",

    -- lsp
    "lspinfo",

    -- nvim-treesitter/playground
    "tsplayground",
  },
}

local ignore_buf_change_filetypes = vim.tbl_extend("force", quit_with_q, {
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
