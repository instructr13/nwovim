local M = {}

local data_dir = require("constants.paths").data_dir
local join_paths = require("utils.paths").join_paths

function M.setup()
  vim.opt.termguicolors = true

  vim.opt.number = true
  vim.opt.foldcolumn = "1"
  vim.opt.signcolumn = "auto:2-3"
  vim.opt.winbar = " "
  vim.opt.cmdheight = 0
  vim.opt.laststatus = 3

  -- Make the settings do not override editorconfig
  vim.opt.expandtab = true
  vim.opt.shiftround = true
  vim.opt.shiftwidth = 2
  vim.opt.tabstop = 2
  vim.opt.softtabstop = -1

  vim.opt.foldlevel = 9999

  vim.opt.mouse = "a"
  vim.opt.mousemoveevent = true
  vim.opt.clipboard = { "unnamedplus" }

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
  vim.opt.winaltkeys = "no"

  vim.opt.scrolloff = 4
  vim.opt.sidescrolloff = 16

  vim.opt.showtabline = 2

  vim.opt.cursorline = true
  vim.opt.concealcursor = "nc"
  vim.opt.virtualedit = "onemore"

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

  vim.opt.spell = true

  vim.opt.linespace = 5
  vim.opt.guifont = string.format("%s:h%d", "Console", 11)

  vim.opt.splitkeep = "screen"

  vim.opt.swapfile = false
end

return M
