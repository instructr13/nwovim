local M = {}

-- Handles support for dynamic capabilities registration and unregistration

function M.setup()
  local original_register_capability =
    vim.lsp.handlers["client/registerCapability"]

  local original_unregister_capability =
    vim.lsp.handlers["client/unregisterCapability"]

  vim.lsp.handlers["client/registerCapability"] = function(_, result, ctx)
    -- Intercept capability registration to add our own handlers
    local client_id = ctx.client_id
    local client = vim.lsp.get_client_by_id(client_id)

    for bufnr, _ in ipairs(client.attached_buffers) do
      local cap = {}

      for _, registration in ipairs(result.registrations) do
        local providers =
          vim.lsp._request_name_to_capability[registration.method]

        if providers then
          for _, provider in ipairs(providers) do
            cap = vim.tbl_extend("force", cap or {}, { [provider] = true })
          end
        end
      end

      vim.schedule(function()
        require("lsp.capabilities").register(client, bufnr, cap)
      end)

      _G.__cap = cap
    end

    return original_register_capability(_, result, ctx)
  end

  vim.lsp.handlers["client/unregisterCapability"] = function(_, result, ctx)
    local client_id = ctx.client_id
    local client = vim.lsp.get_client_by_id(client_id)

    for bufnr, _ in ipairs(client.attached_buffers) do
      local cap = {}

      for _, unregistration in ipairs(result.unregistrations) do
        local providers =
          vim.lsp._request_name_to_capability[unregistration.method]

        if providers then
          for _, provider in ipairs(providers) do
            cap = vim.tbl_extend("force", cap or {}, { [provider] = true })
          end
        end
      end

      require("lsp.capabilities").unregister(bufnr, cap)

      _G.__cap = cap
    end

    return original_unregister_capability(_, result, ctx)
  end
end

return M
