local M = {}

local utils = require("utils.lsp")

local function on_attach(client, buffer)
  local keymap = require("utils.keymap").omit("append", "n", "", { buffer = buffer })

  local command = require("utils.command").current_buf_command

  local cap = client.server_capabilities

  if cap["hoverProvider"] then
    keymap("K", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()

      if not winid then
        vim.lsp.buf.hover()
      end
    end, "Hover")
  end

  if cap["codeActionProvider"] then
    keymap("<F4>", function()
      vim.lsp.buf.code_action()
    end, "Code Action")
  end

  if cap["renameProvider"] then
    keymap("gr", function()
      vim.lsp.buf.rename()
    end, "Rename")
  end

  if cap["signatureHelpProvider"] then
    command("LspSignatureHelp", function()
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

    command("LspDefinition", function()
      definition()
    end, "Go To Defenition")

    keymap("gd", function()
      definition()
    end, "Go To Definition")
  end

  if cap["declarationProvider"] then
    command("LspDeclaration", function()
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

    command("LspTypeDefinition", function()
      type_definition()
    end, "Go To Type Definition")

    keymap("go", function()
      type_definition()
    end, "Go To Type Definition")
  end

  if cap["implementationProvider"] then
    command("LspImplementation", function()
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

    command("LspReferences", function()
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
    command("LspDocumentSymbol", function()
      require("telescope.builtin").lsp_document_symbols()
    end, "Document Symbol")

    keymap("<leader>lsd", function()
      require("telescope.builtin").lsp_document_symbols()
    end, "Document Symbol")

    local ok, navic = pcall(require, "nvim-navic")

    if ok and client.config.name ~= "null-ls" then
      navic.attach(client, buffer)
    end
  end

  if cap["workspaceSymbolProvider"] then
    command(
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

    command("LspAllWorkspaceSymbol", function()
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
    command("LspIncomingCalls", function()
      require("telescope.builtin").lsp_incoming_calls()
    end, "Incoming Calls")

    command("LspOutgoingCalls", function()
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
    command("LspCodeLensRun", function()
      vim.lsp.codelens.run()
    end, "Run CodeLens")

    keymap("<leader>ll", function()
      vim.lsp.codelens.run()
    end, "Run CodeLens")
  end

  command("LspWorkspaceFolders", function()
    utils.list_workspace_folders()
  end, "Workspace Folders")

  command("LspAddWorkspaceFolder", function(args)
    vim.lsp.buf.add_workspace_folder(args.args ~= "" and vim.fn.fnamemodify(args.args, ":p"))
  end, "Add Workspace Folder", { nargs = "?", complete = "dir" })

  command(
    "LspRemoveWorkspaceFolder",
    function(args)
      vim.lsp.buf.remove_workspace_folder(unpack(args.fargs))
    end,
    "Remove Workspace Folder",
    {
      nargs = "?",
      complete = function()
        return vim.lsp.buf.list_workspace_folders()
      end,
    }
  )

  keymap("<leader>lwf", function()
    utils.list_workspace_folders()
  end, "Workspace Folders")

  keymap("<leader>lwa", function()
    vim.lsp.buf.add_workspace_folder()
  end, "Add Workspace Folder")

  keymap("<leader>lwr", function()
    vim.lsp.buf.remove_workspace_folder()
  end, "Remove Workspace Folder")

  command("LspLog", "execute '<mods> pedit +$' v:lua.vim.lsp.get_log_path()", "LSP Log")
end

local function common(server_name, opts)
  opts = opts or {}

  require("lspconfig")[server_name].setup(vim.tbl_deep_extend("error", {
    on_attach = on_attach
  }, opts))
end

-- Register common handlers
M[1] = common

function M.lua_ls()
  require("neodev").setup()

  common("lua_ls", {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace"
        },
        hint = {
          enable = true
        },
        telemetry = {
          enable = false
        }
      }
    }
  })
end

return M
