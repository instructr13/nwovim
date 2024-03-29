local M = {}

local utils_keymap = require("utils.keymap")
local utils_command = require("utils.command")

function M.make_capabilities()
  return vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities(),
    {
      textDocument = {
        foldingRange = {
          dynamicRegistration = false,
          lineFoldingOnly = true,
        },
      },
    }
  )
end

---Locally configure Neovim with the given server capabilities.
---@param client lsp.Client Desired client
---@param buffer number Buffer number
---@param _cap table? Server dynamic capabilities if has
function M.register(client, buffer, _cap)
  local keymap = utils_keymap.omit("append", "n", "", { buffer = buffer })
  local command = utils_command.buf_command

  local cap = _cap or client.server_capabilities

  if cap["renameProvider"] then
    keymap("gr", function()
      vim.lsp.buf.rename()
    end, "Rename")
  end

  if cap["signatureHelpProvider"] then
    command(buffer, "LspSignatureHelp", function()
      vim.lsp.buf.signature_help()
    end, "Get Signature Help")

    keymap("gs", function()
      vim.lsp.buf.signature_help()
    end, "Get Signature Help")
  end

  if cap["definitionProvider"] or cap["referencesProvider"] then
    command(buffer, "LspDefinitionOrReferences", function()
      require("definition-or-references").definition_or_references()
    end, "Go To Defenition")

    keymap("gd", function()
      require("definition-or-references").definition_or_references()
    end, "Go To Definition")

    keymap("<C-LeftMouse>", function()
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes("<LeftMouse>", false, false, true),
        "in",
        false
      )

      -- defer to let nvim refresh to get correct position
      vim.defer_fn(function()
        require("definition-or-references").definition_or_references()
      end, 0)
    end)
  end

  if cap["referencesProvider"] then
    keymap("<a-n>", function()
      require("illuminate").next_reference({ wrap = true })
    end, "Next Reference")
    keymap("<a-p>", function()
      require("illuminate").next_reference({ wrap = true, reverse = true })
    end, "Previous Reference")
  end

  if cap["declarationProvider"] then
    command(buffer, "LspDeclaration", function()
      vim.lsp.buf.declaration()
    end, "Go To Declaration")

    keymap("gD", function()
      vim.lsp.buf.declaration()
    end, "Go To Declaration")
  end

  if cap["typeDefinitionProvider"] then
    local function type_definition()
      local ok, trouble = pcall(require, "trouble")

      if not ok then
        vim.lsp.buf.type_definition()

        return
      end

      trouble.toggle("lsp_type_definitions")
    end

    command(buffer, "LspTypeDefinition", function()
      type_definition()
    end, "Go To Type Definition")

    keymap("go", function()
      type_definition()
    end, "Go To Type Definition")
  end

  if cap["implementationProvider"] then
    command(buffer, "LspImplementation", function()
      vim.lsp.buf.implementation()
    end, "Go To Implementation")

    keymap("gI", function()
      vim.lsp.buf.implementation()
    end, "Go To Implementation")
  end

  if cap["documentSymbolProvider"] then
    local ok, navic = pcall(require, "nvim-navic")

    if ok and client.config.name ~= "null-ls" then
      navic.attach(client, buffer)
    end
  end

  if cap["workspaceSymbolProvider"] then
    command(
      buffer,
      "LspWorkspaceSymbol",
      function(args)
        if args.args == "" then
          require("telescope.builtin").lsp_workspace_symbols()
        else
          vim.lsp.buf.workspace_symbol(args.args)
        end
      end,
      "Workspace Symbol",
      {
        nargs = "*",
      }
    )

    command(buffer, "LspAllWorkspaceSymbol", function()
      require("telescope.builtin").lsp_dynamic_workspace_symbols()
    end, "All Workspace Symbol")

    keymap("<leader>lsw", function()
      require("telescope.builtin").lsp_workspace_symbols()
    end, "Workspace Symbol")

    keymap("<leader>lsW", function()
      require("telescope.builtin").lsp_dynamic_workspace_symbols()
    end, "All Workspace Symbol")
  end

  if cap["callHierarchyProvider"] then
    command(buffer, "LspIncomingCalls", function()
      require("telescope.builtin").lsp_incoming_calls()
    end, "Incoming Calls")

    command(buffer, "LspOutgoingCalls", function()
      require("telescope.builtin").lsp_outgoing_calls()
    end, "Outgoing Calls")

    keymap("<leader>lci", function()
      require("telescope.builtin").lsp_incoming_calls()
    end, "Incoming Calls")

    keymap("<leader>lco", function()
      require("telescope.builtin").lsp_outgoing_calls()
    end, "Outgoing Calls")
  end

  if cap["codeLensProvider"] then
    command(buffer, "LspCodeLensRun", function()
      vim.lsp.codelens.run()
    end, "Run CodeLens")

    keymap("<leader>ll", function()
      vim.lsp.codelens.run()
    end, "Run CodeLens")
  end

  if cap["inlayHintProvider"] and vim.lsp.inlay_hint ~= nil then
    vim.lsp.inlay_hint.enable(buffer, true)

    keymap("<leader>uh", function()
      local value = not vim.lsp.inlay_hint.is_enabled(buffer)

      vim.lsp.inlay_hint.enable(buffer, value)
    end, "Toggle inlay hints")

    vim.api.nvim_create_autocmd({ "LspDetach" }, {
      buffer = buffer,
      desc = "Disable inlay hints",
      callback = function()
        vim.lsp.inlay_hint.enable(buffer, false)
      end,
    })
  end
end

---Remove configured keymaps and commands with the given server capabilities.
---@param buffer number Buffer number
---@param cap table Capabilities table
function M.unregister(buffer, cap)
  local function unmap(modes, lhs, opts_)
    local opts = vim.tbl_extend("force", opts_ or {}, { buffer = buffer })

    -- Ignore errors
    pcall(vim.keymap.del, modes, lhs, opts)
  end

  local function del_command(name)
    -- Ignore errors
    pcall(utils_command.del_buf_command, buffer, name)
  end

  if cap["hoverProvider"] then
    unmap("n", "K")
  end

  if cap["codeActionProvider"] then
    unmap({ "n", "v" }, "<F4>")
  end

  if cap["renameProvider"] then
    unmap("n", "gr")
  end

  if cap["signatureHelpProvider"] then
    del_command("LspSignatureHelp")

    unmap("n", "gs")
  end

  if cap["definitionProvider"] then
    del_command("LspDefinition")

    unmap("n", "gd")
  end

  if cap["declarationProvider"] then
    del_command("LspDeclaration")

    unmap("n", "gD")
  end

  if cap["typeDefinitionProvider"] then
    del_command("LspTypeDefinition")

    unmap("n", "go")
  end

  if cap["implementationProvider"] then
    del_command("LspImplementation")

    unmap("n", "gI")
  end

  if cap["referencesProvider"] then
    del_command("LspReferences")

    unmap("n", "gR")

    unmap("n", "<a-n>")
    unmap("n", "<a-p>")
  end

  if cap["workspaceSymbolProvider"] then
    del_command("LspWorkspaceSymbol")
    del_command("LspAllWorkspaceSymbol")

    unmap("n", "<leader>lsw")
    unmap("n", "<leader>lsW")
  end

  if cap["callHierarchyProvider"] then
    del_command("LspIncomingCalls")
    del_command("LspOutgoingCalls")

    unmap("n", "<leader>lci")
    unmap("n", "<leader>lco")
  end

  if cap["codeLensProvider"] then
    del_command("LspCodeLensRun")

    unmap("n", "<leader>ll")
  end

  if cap["inlayHintProvider"] and vim.lsp.inlay_hint ~= nil then
    vim.lsp.inlay_hint.enable(buffer, false)
  end
end

return M
