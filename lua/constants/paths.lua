local M = {}

local os = require("utils.os")

M.path_sep = os.is_windows and "\\" or "/"
M.config_dir = vim.fn.stdpath("config")
M.cache_dir = vim.fn.stdpath("cache")
M.data_dir = vim.fn.stdpath("data")
M.state_dir = vim.fn.stdpath("state")

return M
