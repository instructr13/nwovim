local fn, uv = vim.fn, vim.loop

local data_dir = require("constants.paths").data_dir
local join_paths = require("utils.paths").join_paths

local plugin_manager_repo = "folke/lazy.nvim"
local plugin_manager_name = "lazy"
local plugin_manager_identifier = "lazy.nvim"
local plugin_manager_path =
  join_paths(data_dir, plugin_manager_name, plugin_manager_identifier)

local M = {}

function M.disable_builtin_plugins()
  vim.g.loaded_man = 1
  vim.g.loaded_zip = 1
  vim.g.loaded_tar = 1

  vim.g.loaded_getscript = 1
  vim.g.loaded_getscriptPlugin = 1
  vim.g.loaded_vimball = 1
  vim.g.loaded_vimballPlugin = 1
  vim.g.loaded_tutor_mode_plugin = 1
  vim.g.loaded_spellfile_plugin = 1

  vim.g.loaded_logiPat = 1
  vim.g.loaded_rrhelper = 1

  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwSettings = 1
  vim.g.loaded_netrwFileHandlers = 1

  vim.g.loaded_python3_provider = 0
  vim.g.loaded_ruby_provider = 0
  vim.g.loaded_node_provider = 0
  vim.g.loaded_perl_provider = 0
end

local function bootstrap_plugin_manager()
  if uv.fs_stat(plugin_manager_path) then
    return
  end

  fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    string.format("https://github.com/%s", plugin_manager_repo),
    "--branch=stable",
    plugin_manager_path,
  })
end

function M.setup()
  bootstrap_plugin_manager()

  vim.opt.rtp:prepend(plugin_manager_path)

  local spec = {
    { import = "load_every.packs" },
    { "LazyVim/LazyVim", import = "load_every.packs_imports" },
  }

  if not vim.g.vscode then
    table.insert(spec, { import = "packs" })
    table.insert(spec, { import = "packs_imports" })
  end

  require("lazy").setup({
    spec = spec,
    defaults = {
      lazy = false,
      version = false,
    },
    diff = {
      cmd = "diffview.nvim",
    },
    checker = { enabled = true },
    install = {
      colorscheme = require("colorschemes").default_colorschemes,
    },
    ui = {
      border = "rounded",
    },
    performance = {
      rtp = {
        disabled_plugins = {
          "gzip",
          "matchit",
          "matchparen",
          "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
  })
end

return M
