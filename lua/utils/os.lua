local M = {}

if jit then
  local os_name = jit.os

  M.is_windows = os_name == "Windows"
  M.is_linux = os_name == "Linux"
else
  local os_name = vim.loop.os_uname().sysname

  M.is_windows = os_name == "Windows" or os_name == "Windows_NT"
  M.is_linux = os_name == "linux"
end

return M
