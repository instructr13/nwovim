local M = {}

local data_dir = require("constants.paths").data_dir
local join_paths = require("utils.paths").join_paths

function M.setup()
  vim.opt.number = true
  vim.opt.foldcolumn = "1"
  vim.opt.signcolumn = "auto:2-3"
  vim.opt.winbar = " "
  vim.opt.cmdheight = 0
  vim.opt.laststatus = 3

  -- Make the settings do not override editorconfig
  vim.opt.expandtab = true
  vim.opt.tabstop = 2
  vim.opt.shiftwidth = 0
  vim.opt.shiftround = true
  vim.opt.softtabstop = -1

  vim.opt.foldlevel = 9999

  vim.opt.mouse = "a"
  vim.opt.mousemoveevent = true

  vim.opt.updatetime = 100
  vim.opt.redrawtime = 1500
  vim.opt.timeoutlen = 350
  vim.opt.ttimeoutlen = 10

  vim.opt.showmode = false
  vim.opt.cmdheight = 0
  vim.opt.history = 10000

  vim.opt.title = true
  vim.opt.titlestring = "%<%F%=%l/%L - nvim"

  vim.opt.grepformat = "%f:%l:%c:%m"
  vim.opt.grepprg = "rg --hidden --vimgrep --smart-case --"

  vim.opt.wrapscan = true
  vim.opt.ignorecase = true
  vim.opt.smartcase = true
  vim.opt.infercase = true

  vim.opt.inccommand = ""

  vim.opt.textwidth = 80
  vim.opt.colorcolumn = "+1"

  vim.opt.wrap = false
  vim.opt.breakat:append([[、。・\ ]])
  vim.opt.breakindent = true

  vim.opt.breakindentopt = {
    shift = 2,
    min = 20,
  }

  vim.opt.showbreak = "⌐"
  vim.opt.cpoptions:append("n")

  vim.opt.whichwrap = {
    b = true,
    s = true,
    ["<"] = true,
    [">"] = true,
    ["["] = true,
    ["]"] = true,
    h = true,
    l = true,
  }

  vim.opt.hidden = true
  vim.opt.splitbelow = true
  vim.opt.splitright = true
  vim.opt.switchbuf = "useopen"

  vim.opt.smartindent = true

  vim.opt.shortmess:append("cmsW")

  vim.opt.pumheight = 10
  vim.opt.winfixheight = true
  vim.opt.winfixwidth = true
  vim.opt.winminwidth = 5
  vim.opt.winaltkeys = "no"

  vim.opt.sidescrolloff = 16

  vim.opt.showtabline = 2

  vim.opt.cursorline = true
  vim.opt.concealcursor = "nc"
  vim.opt.virtualedit = "block"

  vim.opt.formatoptions:remove("cro")
  vim.opt.formatoptions:append("1Mjlmnq")

  vim.opt.matchpairs = {
    "(:)",
    "{:}",
    "[:]",
    "「:」",
    "（:）",
    "【:】",
    "『:』",
    "［:］",
    "｛:｝",
    "《:》",
    "〈:〉",
    "‘:’",
    "“:”",
  }

  vim.opt.jumpoptions = "stack"

  vim.opt.fillchars = {
    eob = " ",
    foldopen = "",
    foldsep = " ",
    foldclose = "",
    diff = "╱",
  }

  vim.opt.list = false
  vim.opt.listchars = {
    eol = "¬",
    precedes = "<",
    extends = ">",
    nbsp = "•",
  }

  vim.opt.viewoptions = {
    "cursor",
    "folds",
    "curdir",
    "slash",
    "unix",
  }

  vim.opt.synmaxcol = 2500

  -- backup is executed by other plugin
  vim.opt.backup = false
  vim.opt.writebackup = false
  vim.opt.confirm = true

  vim.opt.autowrite = true
  vim.opt.writeany = true

  vim.opt.sessionoptions = {
    "buffers",
    "curdir",
    "folds",
    "globals",
    "help",
    "winsize",
    "winpos",
    "tabpages",
    "terminal",
  }

  vim.opt.sh = vim.env.SHELL

  vim.opt.errorbells = false

  vim.opt.exrc = true
  vim.opt.secure = true

  vim.opt.undodir = join_paths(data_dir, "undos")
  vim.opt.undofile = true

  vim.opt.spelllang:append("cjk")

  vim.opt.conceallevel = 2

  vim.opt.linespace = 8

  vim.opt.splitkeep = "screen"

  vim.opt.swapfile = false

  if vim.fn.has("NVIM-0.10") == 1 then
    vim.opt.smoothscroll = true
  end

  if vim.g.neovide then
    local function neovide_rpc(method, ...)
      return vim.rpcrequest(vim.g.neovide_channel_id, method, ...)
    end

    vim.opt.winblend = 24
    vim.g.neovide_hide_mouse_when_typing = true
    vim.g.neovide_remember_window_size = true
    vim.g.neovide_input_macos_alt_is_meta = false
    vim.g.neovide_input_ime = false
    vim.g.neovide_unlink_border_highlights = true
    vim.g.neovide_cursor_animate_in_insert_mode = false

    local function neovide_copy(lines)
      return neovide_rpc("neovide.set_clipboard", lines)
    end

    local function neovide_paste()
      return neovide_rpc("neovide.get_clipboard")
    end

    vim.g.clipboard = {
      name = "neovide",
      copy = {
        ["+"] = neovide_copy,
        ["*"] = neovide_copy,
      },
      paste = {
        ["+"] = neovide_paste,
        ["*"] = neovide_paste,
      },
      cache_enabled = 0,
    }
  end
end

return M
