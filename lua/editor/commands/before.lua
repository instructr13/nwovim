local command = vim.api.nvim_create_user_command

local toggle = require("utils.toggle")

command("SpellToggle", function()
  toggle.toggle_option("spell")
end, { nargs = 0, desc = "Toggle spell checking" })

command("WrapToggle", function()
  toggle.toggle_option("wrap")
end, { nargs = 0, desc = "Toggle word wrapping" })

command("RelativeNumberToggle", function()
  toggle.toggle_option("relativenumber")
end, { nargs = 0, desc = "Toggle relative line numbers" })

command("NumberToggle", function()
  toggle.toggle_number()
end, { nargs = 0, desc = "Toggle line numbers" })

command("DiagnosticsToggle", function()
  toggle.toggle_diagnostics()
end, { nargs = 0, desc = "Toggle diagnostics" })

command("DiagnosticsEnable", function()
  vim.diagnostic.enable()
end, { nargs = 0, desc = "Enable diagnostics" })

command("DiagnosticsDisable", function()
  vim.diagnostic.disable()
end, { nargs = 0, desc = "Disable diagnostics" })

command("ConcealToggle", function()
  toggle.toggle_option(
    "conceallevel",
    false,
    { 0, vim.o.conceallevel > 0 and vim.o.conceallevel or 3 }
  )
end, { nargs = 0, desc = "Toggle conceal" })
