local utils = require("utils.lsp")

---@param client lsp.Client
---@param buffer number
return function(client, buffer)
  local leader =
    require("utils.keymap.presets").leader("n", "", { buffer = buffer })

  local command = require("utils.command").current_buf_command

  require("lsp.capabilities").register(client, buffer)

  command("LspWorkspaceFolders", function()
    utils.list_workspace_folders()
  end, "Workspace Folders")

  command("LspAddWorkspaceFolder", function(args)
    vim.lsp.buf.add_workspace_folder(
      args.args ~= "" and vim.fn.fnamemodify(args.args, ":p")
    )
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

  leader("lwf", function()
    utils.list_workspace_folders()
  end, "Workspace Folders")

  leader("lwa", function()
    vim.lsp.buf.add_workspace_folder()
  end, "Add Workspace Folder")

  leader("lwr", function()
    vim.lsp.buf.remove_workspace_folder()
  end, "Remove Workspace Folder")

  command(
    "LspLog",
    "execute '<mods> pedit +$' v:lua.vim.lsp.get_log_path()",
    "LSP Log"
  )
end
