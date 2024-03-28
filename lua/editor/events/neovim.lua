local autocmd = vim.api.nvim_create_autocmd

local augroup = function(name, opts)
  opts = opts or {}

  return vim.api.nvim_create_augroup(name, opts)
end

autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

autocmd("User", {
  desc = "Enable spell only for normal files",
  group = augroup("spell", { clear = true }),
  pattern = "NormalFile",
  callback = function()
    vim.opt_local.spell = true
  end,
})

autocmd("BufEnter", {
  desc = "Change directory when opened files on home directory",
  group = augroup("working_directory", { clear = true }),
  once = true,
  pattern = "*",
  callback = function()
    if vim.api.nvim_buf_get_name(0) == "" then
      return
    end

    local path = vim.fn.expand("%:p:h")

    if path == vim.env.HOME then
      vim.cmd.cd("%:p")
    end
  end,
})
