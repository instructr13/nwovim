-- Non-plugin-related keymaps

local keymap = require("utils.keymap").keymap
local constants = require("constants.buffers")

keymap("n", "<Space>", "")

vim.g.mapleader = " "
vim.g.maplocalleader = ","

local bufnr_keymap = function(bufnr)
  keymap("n", "<leader>" .. bufnr, function()
    local ok, bufferline = pcall(require, "bufferline")

    if not ok then
      vim.cmd.b(bufnr)

      return
    end

    bufferline.go_to(bufnr)
  end, "Buffer #" .. bufnr)
end

for i = 1, 9 do
  bufnr_keymap(i)
end

-- buffer movement, will be overidden by cybu.nvim
keymap("n", "<Tab>", function()
  local filetype = vim.opt_local.filetype:get()

  if
    vim.tbl_contains(
      require("constants.buffers").window.ignore_buf_change_filetypes,
      filetype
    )
  then
    return
  end

  vim.cmd.bnext()
end, "Next Buffer")

keymap("n", "<S-Tab>", function()
  local filetype = vim.opt_local.filetype:get()

  if
    vim.tbl_contains(
      require("constants.buffers").window.ignore_buf_change_filetypes,
      filetype
    )
  then
    return
  end

  vim.cmd.bprev()
end, "Previous Buffer")

keymap("n", "Y", "yg$", "Yank after cursor")

-- join lines without moving cursor
keymap("n", "J", "mzJ`z", "Join lines")

-- better searching, will be replaced with cinnamon.nvim configuration
keymap("n", "n", "nzzzv", "Next search hit")
keymap("n", "N", "Nzzzv", "Previous search hit")

-- better terminal esc
keymap("t", "<Esc>", [[<C-\><C-n>]], "Escape from Terminal")

-- split undo with
local function split_undo_keymap(key)
  keymap("i", key, key .. "<C-g>u")
end

split_undo_keymap(",")
split_undo_keymap("!")
split_undo_keymap(".")
split_undo_keymap("?")
split_undo_keymap("_")
split_undo_keymap("<cr>")

for _, filetype in ipairs(constants.window.quit_with_q.filetypes) do
  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetype,
    callback = function()
      keymap(
        "n",
        "q",
        function()
          vim.cmd.close()
        end,
        "Quit",
        {
          buffer = true,
        }
      )
    end,
  })
end

for _, buftype in ipairs(constants.window.quit_with_q.buftypes) do
  vim.api.nvim_create_autocmd("BufRead", {
    pattern = "*",
    callback = function()
      if vim.opt_local.buftype:get() == buftype then
        keymap(
          "n",
          "q",
          function()
            vim.cmd.close()
          end,
          "Quit",
          {
            buffer = true,
          }
        )
      end
    end,
  })
end

keymap("n", "<leader>lI", function()
  vim.cmd("LspInfo")
end, "LSP Information", { silent = true })

keymap("n", "gl", function()
  vim.diagnostic.open_float()
end, "Show diagnostics in a floating window")

keymap("n", "[d", function()
  vim.diagnostic.goto_prev()
end, "Move to the previous diagnostic")

keymap("n", "]d", function()
  vim.diagnostic.goto_next()
end, "Move to the next diagnostic")

keymap("c", "<C-f>", "<Nop>")
keymap("n", "q:", "<Nop>")

keymap("n", "<esc>", function()
  require("notify").dismiss({})

  vim.cmd("let @/=''")
end, "Nohlsearch / Dissmiss notifications")

keymap("n", "j", function()
  if vim.v.count == 0 then
    return "gj"
  else
    return "j'"
  end
end, "Move cursor down", { expr = true })

keymap("n", "k", function()
  if vim.v.count == 0 then
    return "gk"
  else
    return "k'"
  end
end, "Move cursor up", { expr = true })

-- split and vsplit
keymap("n", "-", "<cmd>split<cr>", "Split horizontally")
keymap("n", "|", "<cmd>vsplit<cr>", "Split vertically")

keymap("i", "<C-BS>", "<C-w>", "Kill word")

keymap("n", "x", function()
  if vim.fn.col(".") == 1 then
    local line = vim.api.nvim_get_current_line()

    if line:match("^%s*$") then
      vim.cmd("normal! dd$")
    else
      vim.cmd("normal! " .. (vim.v.count > 0 and vim.v.count or "") .. '"_x')
    end
  else
    vim.cmd("normal! " .. (vim.v.count > 0 and vim.v.count or "") .. '"_x')
  end
end, "Delete character without yanking")

keymap("v", "x", '"_x', "Delete character without yanking")

keymap("x", "<", "<gv", "Shift left and reselect")
keymap("x", ">", ">gv", "Shift left and reselect")

