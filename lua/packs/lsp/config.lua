local M = {}

function M.format_setup()
  local group = vim.api.nvim_create_augroup("LspAttach_lsp_format", {})

  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args)
      if not (args.data and args.data.client_id) then
        return
      end

      local client = vim.lsp.get_client_by_id(args.data.client_id)

      if client.supports_method("textDocument/formatting") then
        local buffer = args.buf
        local keymap =
            require("utils.keymap").omit("append", "n", "", { buffer = buffer })

        require("lsp-format").on_attach(client)

        vim.cmd("cabbrev wq execute 'Format sync' <bar> wq")

        keymap("<F3>", function()
          require("lsp-format").format()
        end, "Format")
      end
    end,
  })
end

return M
