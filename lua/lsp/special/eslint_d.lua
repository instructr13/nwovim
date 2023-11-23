local Path = require("plenary.path")

local root_pattern = require("lspconfig.util").root_pattern

local M = {}

function M.get_config_type(bufnr)
  bufnr = bufnr or 0

  local path = vim.api.nvim_buf_get_name(bufnr)

  local flat_config_cwd = root_pattern({
    "eslint.config.js",
  })(path)

  if flat_config_cwd then
    return "flat", flat_config_cwd
  end

  local classic_config_cwd = root_pattern({
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.json",
    ".eslintrc.yml",
    ".eslintrc.yaml",
  })(path)

  if classic_config_cwd then
    return "classic", classic_config_cwd
  end

  return false
end

function M.has_config(bufnr)
  bufnr = bufnr or 0

  local type = M.get_config_type(bufnr)

  if type == "flat" or type == "classic" then
    return true
  end

  local package_json_dir = root_pattern({
    "package.json",
  })(vim.api.nvim_buf_get_name(bufnr))

  if not package_json_dir then
    return false
  end

  local package_json = Path:new(package_json_dir):joinpath("package.json")

  if not package_json:is_file() then
    return false
  end

  local read_ok, contents = pcall(function()
    return package_json:read()
  end)

  if not read_ok then
    return false
  end

  local decode_ok, obj = pcall(vim.json.decode, contents)

  if not decode_ok then
    return false
  end

  if obj.eslintConfig then
    return true
  end

  return false
end

return M
