local M = {}

function M.dap_setup()
  local keymap_function = require("utils.keymap").omit("insert", "n", "<^%>")

  keymap_function("F5", function()
    require("dap").continue()
  end, "Debugger: Start")

  keymap_function("F17", function() -- Shift + F5
    require("dap").terminate()
  end, "Debugger: Stop")

  keymap_function("F29", function() -- Control + F5
    require("dap").restart_frame()
  end, "Debugger: Restart")

  keymap_function("F9", function()
    require("dap").toggle_breakpoint()
  end, "Debugger: Toggle Breakpoint")

  keymap_function("F21", function() -- Shift + F9
    vim.ui.input({
      prompt = "Breakpoint condition: ",
    }, function(condition)
      if not condition then
        return
      end

      require("dap").set_breakpoint(condition)
    end)
  end, "Debugger: Set Conditional Breakpoint")

  keymap_function("F33", function() -- Control + F9
    vim.ui.input({
      prompt = "Logpoint message: ",
    }, function(message)
      if not message then
        return
      end

      require("dap").set_breakpoint(nil, nil, message)
    end)
  end, "Debugger: Set Logpoint")

  keymap_function("F10", function()
    require("dap").step_over()
  end, "Debugger: Step Over")

  keymap_function("F11", function()
    require("dap").step_into()
  end, "Debugger: Step Into")

  keymap_function("F23", function() -- Shift + F11
    require("dap").step_out()
  end, "Debugger: Step Out")

  local keymap = require("utils.keymap").keymap

  keymap("n", "<leader>dB", function()
    require("dap").clear_breakpoints()
  end, "Clear Breakpoints")

  keymap("n", "<leader>dq", function()
    require("dap").close()
  end, "Close Session")

  keymap("n", "<leader>dR", function()
    require("dap").repl.toggle()
  end, "Toggle REPL")

  keymap("n", "<leader>ds", function()
    require("dap").run_to_cursor()
  end, "Run To Cursor")

  keymap("n", "<leader>de", function()
    vim.ui.input({ prompt = "Expression: " }, function(expr)
      if expr then
        require("dapui").eval(expr)
      end
    end)
  end, "Evaluate Input")

  keymap("n", "<leader>du", function()
    require("dapui").toggle()
  end, "Toggle Debugger UI")

  keymap("n", "<leader>dh", function()
    require("dap.ui.widgets").hover()
  end, "Hover")
end

function M.dap()
  local dap = require("dap")

  require("mason-nvim-dap")
  require("nvim-dap-virtual-text")

  dap.listeners.after.event_initialized["dapui_config"] = function()
    require("dapui").open()
  end

  dap.listeners.before.event_terminated["dapui_config"] = function()
    require("dapui").close()
  end

  dap.listeners.before.event_exited["dapui_config"] = function()
    require("dapui").close()
  end

  -- Define signs
  vim.fn.sign_define("DapBreakpoint", {
    text = " ",
    texthl = "DapBreakpoint",
    linehl = "",
    numhl = "",
  })

  vim.fn.sign_define("DapBreakpointCondition", {
    text = " ",
    texthl = "DapBreakpointCondition",
    linehl = "",
    numhl = "",
  })

  vim.fn.sign_define("DapLogPoint", {
    text = " ",
    texthl = "DapLogPoint",
    linehl = "",
    numhl = "",
  })

  vim.fn.sign_define("DapStopped", {
    text = " ",
    texthl = "DapStopped",
    linehl = "",
    numhl = "",
  })

  require("dap.ext.vscode").load_launchjs()
end

return M
