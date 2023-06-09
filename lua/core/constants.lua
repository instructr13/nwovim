local M = {}

local os_name
local is_windows
local is_linux

if jit then
  os_name = jit.os

  is_windows = os_name == "Windows"
  is_linux = os_name == "Linux"
else
  os_name = vim.loop.os_uname().sysname

  is_windows = os_name == "Windows" or os_name == "Windows_NT"
  is_linux = os_name == "linux"
end

function M.setup()
  local path_sep = is_windows and "\\" or "/"
  local config_dir = vim.fn.stdpath("config")
  local cache_dir = vim.fn.stdpath("cache")
  local data_dir = vim.fn.stdpath("data")

  _G.path_sep = path_sep
  _G.config_dir = config_dir
  _G.cache_dir = cache_dir
  _G.data_dir = data_dir

  function _G.join_paths(...)
    return table.concat({ ... }, path_sep)
  end
end

local quit_with_q = {
  buftypes = {
    "quickfix",
  },
  filetypes = {
    --help
    "help",

    -- vim-dadbod
    "dbout",

    -- lsp
    "lspinfo",

    -- vim-startuptime
    "startuptime",
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

M.os_name = os_name
M.is_windows = is_windows
M.is_linux = is_linux

M.window = {
  quit_with_q = quit_with_q,
  ignore_buf_change_filetypes = ignore_buf_change_filetypes
}

return M

