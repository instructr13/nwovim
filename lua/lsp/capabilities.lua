local M = {}

local utils_keymap = require("utils.keymap")
local utils_command = require("utils.command")

function M.make_capabilities()
  return vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities()
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

  _G.__cap = {}

  table.insert(_G.__cap, cap)

  if cap["hoverProvider"] then
    keymap("K", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()

      if not winid then
        vim.lsp.buf.hover()
      end
    end, "Hover")
  end

  if cap["codeActionProvider"] then
    require("utils.keymap").keymap({ "n", "v" }, "<F4>", function()
      vim.lsp.buf.code_action()
    end, "Code Action")
  end

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

  if cap["definitionProvider"] then
    local function definition()
      local ok, trouble = pcall(require, "trouble")

      if not ok then
        vim.lsp.buf.definition()

        return
      end

      trouble.toggle("lsp_definitions")
    end

    command(buffer, "LspDefinition", function()
      definition()
    end, "Go To Defenition")

    keymap("gd", function()
      definition()
    end, "Go To Definition")
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

  if cap["referencesProvider"] then
    local function references()
      local ok, trouble = pcall(require, "trouble")

      if not ok then
        vim.lsp.buf.references()

        return
      end

      trouble.toggle("lsp_references")
    end

    command(buffer, "LspReferences", function()
      references()
    end, "Go To References")

    keymap("gR", function()
      references()
    end, "Go To References")

    keymap("<a-n>", function()
      require("illuminate").next_reference({ wrap = true })
    end, "Next Reference")
    keymap("<a-p>", function()
      require("illuminate").next_reference({ wrap = true, reverse = true })
    end, "Previous Reference")
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
end

---Remove configured keymaps and commands with the given server capabilities.
---@param buffer number Buffer number
---@param cap table Capabilities table
function M.unregister(buffer, cap)
  local function unmap(modes, lhs, opts)
    local opts = vim.tbl_extend("force", opts or {}, { buffer = buffer })

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
end

return M