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
