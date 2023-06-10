local api = vim.api

api.nvim_create_autocmd("TextYankPost", {
  group = api.nvim_create_augroup("highlight_yank", {}),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 400,
    })
  end,
  desc = "Highlight yanked text",
})

api.nvim_create_autocmd("TermOpen", {
  group = api.nvim_create_augroup("terminal_opt", {}),
  pattern = "term://*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.cursorline = false
    vim.opt_local.spell = false
    vim.opt_local.signcolumn = "no"
  end,
  desc = "Disable some annoying artifacts in terminal",
})

api.nvim_create_autocmd({ "BufEnter", "WinEnter", "BufWinEnter" }, {
  group = api.nvim_create_augroup("nofile_settings", {}),
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "nofile" or vim.bo.buftype == "quickfix" then
      vim.opt_local.number = false
      vim.opt_local.relativenumber = false
      vim.opt_local.statuscolumn = ""
    end
  end,
  desc = "Disable number on buf with nofile",
})
