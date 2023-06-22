-- Code from https://github.com/NormalNvim/NormalNvim/blob/main/lua/base/3-autocmds.lua

local exec = require("editor.events").exec
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

autocmd("TextYankPost", {
  group = augroup("highlight_yank", {}),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 400,
    })
  end,
  desc = "Highlight yanked text",
})

autocmd("TermOpen", {
  group = augroup("terminal_opt", {}),
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

autocmd({ "BufEnter", "WinEnter", "BufWinEnter" }, {
  group = augroup("nofile_settings", {}),
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

local view_group = augroup("auto_view", { clear = true })

autocmd({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
  group = view_group,
  callback = function(event)
    if vim.b[event.buf].view_activated then
      vim.cmd.mkview({ mods = { emsg_silent = true } })
    end
  end,
})

autocmd("BufWinEnter", {
  group = view_group,
  callback = function(event)
    if not vim.b[event.buf].view_activated then
      local filetype =
        vim.api.nvim_get_option_value("filetype", { buf = event.buf })
      local buftype =
        vim.api.nvim_get_option_value("buftype", { buf = event.buf })
      local ignore_filetypes = { "gitcommit", "gitrebase", "svg", "hgcommit" }

      if
        buftype == ""
        and filetype
        and filetype ~= ""
        and not vim.tbl_contains(ignore_filetypes, filetype)
      then
        vim.b[event.buf].view_activated = true
        vim.cmd.loadview({ mods = { emsg_silent = true } })
      end
    end
  end,
})

autocmd("FileType", {
  desc = "Unlist quickfist buffers",
  group = augroup("unlist_quickfist", { clear = true }),
  pattern = "qf",
  callback = function()
    vim.opt_local.buflisted = false
  end,
})

autocmd("VimEnter", {
  desc = "Disable right contextual menu warning message",
  group = augroup("contextual_menu", { clear = true }),
  callback = function()
    vim.cmd([[aunmenu PopUp.How-to\ disable\ mouse]]) -- Disable right click message
    vim.cmd([[aunmenu PopUp.-1-]]) -- Disable right click message
  end,
})

autocmd({ "BufReadPost", "BufNewFile" }, {
  desc = "Events for the file detection",
  group = augroup("file_user_events", { clear = true }),
  callback = function(args)
    if
      not (vim.fn.expand("%") == "" or vim.bo[args.buf].buftype == "nofile")
    then
      exec("NormalFile")

      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

      if (#lines == 1 and lines[1] ~= "") or #lines ~= 1 then
        vim.loop.spawn("git", {
          args = {
            "-C",
            vim.fn.expand("%:p:h"),
            "rev-parse",
          },
        }, function(code)
          if code == 0 then
            exec("GitFile")
          end
        end)
      end
    end
  end,
})
