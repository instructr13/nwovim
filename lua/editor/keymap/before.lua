-- Non-plugin-related keymaps

local keymap = require("utils.keymap").keymap
local constants = require("constants.buffers")
local toggle = require("utils.toggle")

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

local function bnext()
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
end

local function bprevious()
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
end

keymap("n", "<Tab>", bnext, "Next Buffer")
keymap("n", "<S-Tab>", bprevious, "Previous Buffer")
keymap("n", "]b", bnext, "Next Buffer")
keymap("n", "[b", bprevious, "Previous Buffer")

keymap("n", "Y", "yg$", "Yank after cursor")

-- join lines without moving cursor
keymap("n", "J", "mzJ`z", "Join lines")

-- better search
keymap(
  "n",
  "n",
  "'Nn'[v:searchforward].'zv'",
  "Next search result",
  { expr = true }
)
keymap(
  { "o", "x" },
  "n",
  "'Nn'[v:searchforward]",
  "Next search result",
  { expr = true }
)
keymap(
  "n",
  "N",
  "'nN'[v:searchforward].'zv'",
  "Previous search result",
  { expr = true }
)
keymap(
  { "o", "x" },
  "N",
  "'nN'[v:searchforward]",
  "Previous search result",
  { expr = true }
)

-- better terminal esc
keymap("t", "<esc><esc>", [[<C-\><C-n>]], "Escape from Terminal")

-- split undo with
local function split_undo_keymap(key)
  keymap("i", key, key .. "<C-g>u")
end

split_undo_keymap(";")
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

keymap({ "i", "c" }, "<C-v>", "<C-r>+", "Paste from clipboard")
keymap("i", "<C-r>", "<C-v>", "Insert original character")

local leader = require("utils.keymap.presets").leader("n", "")

leader("K", "<cmd>norm! K<cr>", "Keywordprg")

leader("fn", "<cmd>enew<cr>", "New file")

leader("xl", "<cmd>lopen<cr>", "Open location list")
leader("xq", "<cmd>copen<cr>", "Open quickfix")

leader("us", function()
  toggle.toggle_option("spell")
end, "Toggle spelling")

leader("uw", function()
  toggle.toggle_option("wrap")
end, "Toggle word wrap")

leader("uL", function()
  toggle.toggle_option("relativenumber")
end, "Toggle relative line numbers")

leader("ul", function()
  toggle.toggle_number()
end, "Toggle line numbers")

leader("ud", function()
  toggle.toggle_diagnostics()
end, "Toggle diagnostics")

leader("uc", function()
  toggle.toggle_option(
    "conceallevel",
    false,
    { 0, vim.o.conceallevel > 0 and vim.o.conceallevel or 3 }
  )
end, "Toggle conceal")

leader("Q", "<cmd>qa<cr>", "Quit all")

leader("ww", "<C-W>p", "Other window", { remap = true })
leader("wd", "<C-W>c", "Delete window", { remap = true })
leader("w-", "<C-W>s", "Split window below", { remap = true })
leader("w|", "<C-W>v", "Split window right", { remap = true })
leader("-", "<C-W>s", "Split window below", { remap = true })
leader("|", "<C-W>v", "Split window right", { remap = true })

leader("<tab>l", "<cmd>tablast<cr>", "Last Tab")
leader("<tab>f", "<cmd>tabfirst<cr>", "First Tab")
leader("<tab><tab>", "<cmd>tabnew<cr>", "New Tab")
leader("<tab>]", "<cmd>tabnext<cr>", "Next Tab")
leader("<tab>d", "<cmd>tabclose<cr>", "Close Tab")
leader("<tab>[", "<cmd>tabprevious<cr>", "Previous Tab")
