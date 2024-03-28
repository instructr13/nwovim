local Path = require("plenary.path")

local utils = require("utils.lsp")

local M = {}

function M.is_deno_fmt_available()
  local vscode_config = require("neoconf").get().vscode or {}

  if
    vscode_config.editor
    and vscode_config.editor.defaultFormatter == "denoland.vscode-deno"
  then
    return true
  end
end

function M.is_deno_available(bufnr)
  bufnr = bufnr or 0
  local buffer_file = Path:new(vim.uri_to_fname(vim.uri_from_bufnr(bufnr)))
    :absolute()
  local vscode_config = require("neoconf").get().vscode

  if vscode_config then
    if not vscode_config.deno then
      return false
    end

    local deno_enabled_globally = not not vscode_config.deno.enable

    if not vscode_config.deno.enablePaths then
      return deno_enabled_globally
    end

    local workspace_root = Path:new(
      require("neoconf.workspace").find_root({ buffer = bufnr })
    ):absolute()

    if not workspace_root then
      return deno_enabled_globally
    end

    for _, path in ipairs(vscode_config.deno.enablePaths) do
      local target_path = workspace_root:joinpath(path)

      if
        target_path:exists()
        and vim.startswith(buffer_file, target_path:absoute())
      then
        return true
      end
    end

    return false
  end

  local root_pattern = require("lspconfig.util").root_pattern

  local deno_root = root_pattern({ "deno.json", "deno.jsonc" })(buffer_file)

  local ts_root =
    root_pattern({ "tsconfig.json", "jsconfig.json", "package.json" })(
      buffer_file
    )

  if not deno_root and not ts_root then
    return true -- Behave as Deno with single file
  end

  if deno_root and ts_root then
    return deno_root:len() >= ts_root:len()
  end

  return not not deno_root
end

function M.detach_tsserver_if_enabled(bufnr)
  if not vim.b[bufnr].lsp_enable_deno then
    return
  end

  local tsserver = utils.find_client("tsserver")

  if tsserver and vim.lsp.buf_is_attached(bufnr, tsserver.id) then
    require("utils.lsp").detach_silently(bufnr, tsserver.id)
  end
end

function M.refresh(bufnr)
  vim.b[bufnr].lsp_enable_deno = M.is_deno_available(bufnr)
end

return M
