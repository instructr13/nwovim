local fn, uv = vim.fn, vim.loop

local plugin_manager_repo = "folke/lazy.nvim"
local plugin_manager_name = "lazy"
local plugin_manager_identifier = "lazy.nvim"
local plugin_manager_path = join_paths(data_dir, plugin_manager_name, plugin_manager_identifier)

local M = {}

function M.disable_builtin_plugins()
  vim.g.loaded_man = 1
  vim.g.loaded_gzip = 1
  vim.g.loaded_zip = 1
  vim.g.loaded_zipPlugin = 1
  vim.g.loaded_tar = 1
  vim.g.loaded_tarPlugin = 1

  vim.g.loaded_getscript = 1
  vim.g.loaded_getscriptPlugin = 1
  vim.g.loaded_vimball = 1
  vim.g.loaded_vimballPlugin = 1
  vim.g.loaded_2html_plugin = 1
  vim.g.loaded_tutor_mode_plugin = 1
  vim.g.loaded_spellfile_plugin = 1

  vim.g.loaded_matchit = 1
  vim.g.loaded_matchparen = 1
  vim.g.loaded_logiPat = 1
  vim.g.loaded_rrhelper = 1

  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  vim.g.loaded_netrwSettings = 1
  vim.g.loaded_netrwFileHandlers = 1

  vim.g.loaded_python3_provider = 0
  vim.g.loaded_ruby_provider = 0
  vim.g.loaded_node_provider = 0
  vim.g.loaded_perl_provider = 0
end

local function bootstrap_plugin_manager()
  local stat = uv.fs_stat(plugin_manager_path)

  if stat then
    return
  end

  local command = string.format("git clone https://github.com/%s.git --filter=blob:none --branch=stable %s", plugin_manager_repo, plugin_manager_path)

  fn.system(command)
end

function M.setup()
  bootstrap_plugin_manager()

  vim.opt.rtp:prepend(plugin_manager_path)

  local lazy = require("lazy")

  lazy.setup("packs", {
    checker = { enabled = true }
  })
end

return M

