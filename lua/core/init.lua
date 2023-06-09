local M = {}

local uv, log_levels = vim.loop, vim.log.levels

local constants = require("core.constants")

constants.setup()

local prepare_needed_dirs = function()
  local needed_dirs = {
    data_dir .. path_sep .. "backups",
    cache_dir .. path_sep .. "sessions",
    cache_dir .. path_sep .. "swap",
    cache_dir .. path_sep .. "undos",
  }

  for _, needed_dir in pairs(needed_dirs) do
    local needed_dir_stat, err, err_signature = uv.fs_stat(needed_dir)

    if needed_dir_stat == nil and err_signature ~= "ENOENT" then
      vim.notify("Cannot stat directory: " .. needed_dir .. "\n" .. err, log_levels.ERROR, {
        title = "core",
      })
    elseif err == nil and needed_dir_stat ~= nil and needed_dir_stat.type ~= "directory" then
      vim.notify("Error while preparing " .. needed_dir .. ": This is a " .. needed_dir_stat.type, log_levels.ERROR, {
        title = "core",
      })

      return
    end

    uv.fs_mkdir(needed_dir, 448)
  end
end

local function setup_very_lazy()
  require("diagnostics").setup()
end

function M.setup()
  require("editor.keymap.before")
  require("editor.events.before")

  local pack = require("core.pack")

  prepare_needed_dirs()
  pack.disable_builtin_plugins()

  local options = require("core.options")

  options.setup()

  pack.setup()

  require("colorschemes").setup()

  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    once = true,
    callback = function()
      setup_very_lazy()
    end
  })
end

return M

