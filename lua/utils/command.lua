local M = {}

local check_desc_opts_type = function(desc, opts)
  desc = desc or ""

  if type(desc) == "table" and not opts then
    opts = desc
  else
    if type(desc) == "string" then
      opts = vim.tbl_deep_extend("force", opts or {}, { desc = desc })
    end
  end

  return desc, opts
end

---Create a command for the current buffer.
---@param name string Command name
---@param command string | function Command callback or command string
---@param desc string | table Command description or options
---@param opts table? Command options
function M.current_buf_command(name, command, desc, opts)
  desc, opts = check_desc_opts_type(desc, opts)

  vim.api.nvim_buf_create_user_command(0, name, command, opts)
end

---Remove a command from the current buffer.
---@param name string Command name
function M.del_current_buf_command(name)
  vim.api.nvim_buf_del_user_command(0, name)
end

---Create a command for the given buffer.
---@param bufnr number Buffer number
---@param name string Command name
---@param command string | function Command callback or command string
---@param desc string | table Command description or options
---@param opts table? Command options
function M.buf_command(bufnr, name, command, desc, opts)
  desc, opts = check_desc_opts_type(desc, opts)

  vim.api.nvim_buf_create_user_command(bufnr, name, command, opts)
end

---Remove a command from the given buffer.
---@param bufnr number Buffer number
---@param name string Command name
function M.del_buf_command(bufnr, name)
  vim.api.nvim_buf_del_user_command(bufnr, name)
end

---Create a command.
---@param name string Command name
---@param command string | function Command callback or command string
---@param desc string | table Command description or options
---@param opts table? Command options
function M.command(name, command, desc, opts)
  desc, opts = check_desc_opts_type(desc, opts)

  if opts.buffer then
    if type(opts.buffer) == "boolean" then
      vim.api.nvim_buf_create_user_command(0, name, command, opts)
    elseif type(opts.buffer) == "number" then
      vim.api.nvim_buf_create_user_command(opts.buffer, name, command, opts)
    end
  else
    vim.api.nvim_create_user_command(name, command, opts)
  end
end

---Remove a command.
---@param name string Command name
function M.del_command(name)
  vim.api.nvim_del_user_command(name)
end

return M
