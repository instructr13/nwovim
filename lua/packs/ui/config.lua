local M = {}

local fn = vim.fn

local fsize = require("utils.fsize")

function M.notify()
  require("notify").setup({
    background_colour = function()
      local group_bg = fn.synIDattr(fn.synIDtrans(fn.hlID("Normal")), "bg#")

      if group_bg == "" or group_bg == "none" then
        group_bg = fn.synIDattr(fn.synIDtrans(fn.hlID("Float")), "bg#")

        if group_bg == "" or group_bg == "none" then
          return "#000000"
        end
      end

      return group_bg
    end,
  })

  require("utils.telescope").register_extension("notify")
end

function M.barbecue()
  -- opts field won't work properly, so we have to call setup() in config
  require("barbecue").setup({
    attach_navic = false, -- will be attached by lsp on_attach
    create_autocmd = false,
    theme = "catppuccin",
  })

  vim.api.nvim_create_autocmd({
    "WinResized",
    "BufWinEnter",
    "CursorHold",
    "InsertLeave",
  }, {
    group = vim.api.nvim_create_augroup("barbecue.updater", {}),
    callback = function()
      require("barbecue.ui").update()
    end,
  })
end

function M.statusline()
  local heirline = require("heirline")
  local lib = require("heirline-components.all")
  local conditions = require("heirline.conditions")
  local utils = require("heirline.utils")

  lib.init.subscribe_to_events()

  local palette = require("catppuccin.palettes").get_palette()

  local colors = vim.tbl_extend("error", palette, {
    bright_bg = palette.surface0,
    bright_fg = palette.text,
    dark_red = utils.get_highlight("DiffDelete").bg,
    gray = palette.subtext1,
    orange = palette.peach,
    purple = palette.mauve,
    cyan = palette.sapphire,
    diag_error = utils.get_highlight("DiagnosticError").fg,
    diag_dark_error = utils.get_highlight("DiagnosticVirtualTextError").bg,
    diag_warn = utils.get_highlight("DiagnosticWarn").fg,
    diag_dark_warn = utils.get_highlight("DiagnosticVirtualTextWarn").bg,
    diag_info = utils.get_highlight("DiagnosticInfo").fg,
    diag_dark_info = utils.get_highlight("DiagnosticVirtualTextInfo").bg,
    diag_hint = utils.get_highlight("DiagnosticHint").fg,
    diag_dark_hint = utils.get_highlight("DiagnosticVirtualTextHint").bg,
    git_del = utils.get_highlight("diffDeleted").fg,
    git_add = utils.get_highlight("diffAdded").fg,
    git_change = utils.get_highlight("diffChanged").fg,
  })

  heirline.load_colors(vim.tbl_extend("force", colors, lib.hl.get_colors()))

  local statusline = {
    hl = {
      fg = "gray",
      bg = "mantle",
    },
  }

  -- Utilities
  local Align = { provider = "%=" }
  local Space = { provider = " " }
  local Separator = { provider = " │ ", hl = { fg = "surface0" } }

  local Left = {}

  table.insert(Left, lib.component.mode())

  local function get_diagnostic_object(severity)
    local diagnostics = vim.diagnostic.get(0, { severity = severity })
    local count = #diagnostics
    local first_lnum = count > 0 and diagnostics[1].lnum + 1 or 0

    return count, first_lnum
  end

  local function create_arrow(lnum)
    local row = vim.api.nvim_win_get_cursor(fn.win_getid())[1]

    local arrow = ""

    if row > lnum then
      arrow = ""
    elseif row == lnum then
      arrow = ""
    end

    return arrow
  end

  local FileFlags = {
    condition = function(self)
      return self.filetype ~= "" and vim.bo.buftype == ""
    end,

    {
      update = "BufModifiedSet",

      provider = " ",
      hl = function()
        local fg = vim.bo.modified and "green" or "surface1"

        return { fg = fg }
      end,
    },
    {
      update = { "BufReadPost", "BufNewFile" },

      provider = "",
      hl = function()
        local fg = (not vim.bo.modifiable or vim.bo.readonly) and "orange"
          or "surface1"

        return { fg = fg }
      end,
    },
  }

  Left = utils.insert(
    Left,
    lib.component.file_info({
      file_icon = { -- if set, displays a icon depending the current filetype.
        padding = { left = 0, right = 1 },
      },
      filetype = {
        padding = { right = 1 },
      },
      surround = false,
      file_read_only = false,
    }),
    FileFlags
  )

  local QuickFixBlock = {
    condition = function()
      return vim.bo.buftype == "quickfix"
    end,

    init = function(self)
      self.qflist = fn.getqflist() or {}

      local idx = 1

      for _, i in ipairs(self.qflist) do
        if i.valid == 1 then
          i["_idx"] = idx
          idx = idx + 1
        end
      end
    end,
  }

  local QuickFixIcon = {
    provider = "  ",

    hl = { fg = "green" },
  }

  local QuickFixText = {
    {
      provider = "QF",
    },
    {
      provider = "  ",

      hl = { fg = "overlay0" },
    },
    {
      provider = function(self)
        local idx = fn.getqflist({ idx = 0 }).idx

        if
          #self.qflist > 0
          and idx ~= nil
          and self.qflist[idx]["_idx"] ~= nil
        then
          return self.qflist[idx]["_idx"]
        else
          return 0
        end
      end,

      hl = { bold = true },
    },
    {
      provider = " of ",

      hl = { fg = "overlay0" },
    },
    {
      provider = function(self)
        local count = 0

        if #self.qflist > 0 then
          for _, i in ipairs(self.qflist) do
            if i.valid == 1 then
              count = count + 1
            end
          end
        end

        return count
      end,

      hl = { bold = true },
    },
    {
      condition = function(self)
        self.buffers = {}

        if #self.qflist > 0 then
          for _, t in ipairs(self.qflist) do
            if
              t.valid == 1 and #self.buffers == 0
              or t.valid == 1 and self.buffers[#self.buffers] ~= t.bufnr
            then
              table.insert(self.buffers, t.bufnr)
            end
          end
        end

        return #self.buffers ~= 0
      end,

      {
        provider = " in ",

        hl = { fg = "overlay0" },
      },
      {
        provider = function(self)
          return #self.buffers .. " "
        end,
      },
      {
        provider = function(self)
          return "file" .. (#self.buffers > 1 and "s" or "")
        end,

        hl = { fg = "overlay0" },
      },
    },
  }

  QuickFixBlock =
    utils.insert(QuickFixBlock, QuickFixIcon, QuickFixText, Separator)
  Left = utils.insert(Left, QuickFixBlock)

  local Diagnostics = {
    condition = function(self)
      return self.filetype ~= "" and vim.bo.buftype == ""
    end,

    update = { "DiagnosticChanged", "BufEnter", "CursorHold" },

    static = {
      error_icon = " ",
      warn_icon = " ",
      info_icon = " ",
      hint_icon = " ",
      ok_icon = " ",
    },

    init = function(self)
      self.errors, self.error_lnum =
        get_diagnostic_object(vim.diagnostic.severity.ERROR)
      self.warnings, self.warn_lnum =
        get_diagnostic_object(vim.diagnostic.severity.WARN)
      self.info, self.info_lnum =
        get_diagnostic_object(vim.diagnostic.severity.INFO)
      self.hints, self.hint_lnum =
        get_diagnostic_object(vim.diagnostic.severity.HINT)

      self.ok = self.errors + self.warnings + self.info + self.hints == 0
    end,

    on_click = {
      callback = function()
        require("trouble").toggle({ mode = "document_diagnostics" })
      end,
      name = "heirline_diagnostics",
    },

    Separator,
    {
      provider = function(self)
        return self.error_icon .. self.errors
      end,
      hl = function(self)
        local fg = self.errors > 0 and "diag_error" or "surface1"

        return { fg = fg }
      end,

      {
        condition = function(self)
          return self.errors > 0
        end,

        {
          provider = function(self)
            return create_arrow(self.error_lnum)
          end,

          hl = { fg = "diag_dark_error" },
        },
        {
          provider = function(self)
            return self.error_lnum
          end,

          hl = { fg = "diag_error" },
        },
      },
      Space,
    },
    {
      provider = function(self)
        return self.warn_icon .. self.warnings
      end,
      hl = function(self)
        local fg = self.warnings > 0 and "diag_warn" or "surface1"

        return { fg = fg }
      end,

      {
        condition = function(self)
          return self.warnings > 0
        end,

        {
          provider = function(self)
            return create_arrow(self.warn_lnum)
          end,

          hl = { fg = "diag_dark_warn" },
        },
        {
          provider = function(self)
            return self.warn_lnum
          end,

          hl = { fg = "diag_warn" },
        },
      },
      Space,
    },
    {
      condition = function(self)
        return self.info > 0
      end,

      provider = function(self)
        return self.info_icon .. self.info
      end,

      hl = function(self)
        local fg = self.info > 0 and "diag_info" or "surface1"

        return { fg = fg }
      end,

      {
        provider = function(self)
          return create_arrow(self.info_lnum)
        end,

        hl = { fg = "diag_dark_info" },
      },
      {
        provider = function(self)
          return self.info_lnum
        end,

        hl = { fg = "diag_info" },
      },
      Space,
    },
    {
      condition = function(self)
        return self.hints > 0
      end,
      provider = function(self)
        return self.hint_icon .. self.hints
      end,
      hl = { fg = "diag_hint" },

      {
        provider = function(self)
          return create_arrow(self.hint_lnum)
        end,

        hl = { fg = "diag_dark_hint" },
      },
      {
        provider = function(self)
          return self.hint_lnum
        end,

        hl = { fg = "diag_hint" },
      },
      {
        provider = " ",
      },
    },
    {
      provider = function(self)
        return self.ok_icon
      end,
      hl = function(self)
        local fg = (self.ok and vim.bo.buftype == "") and "green" or "surface1"

        return { fg = fg }
      end,
    },
    Separator,
  }

  Left = utils.insert(Left, Diagnostics)

  local GitBranch = {
    condition = conditions.is_git_repo,

    provider = " ",

    hl = { fg = "orange" },

    {
      provider = function()
        return vim.b.gitsigns_status_dict.head
      end,

      hl = { fg = "text" },
    },
  }

  Left = utils.insert(Left, GitBranch, lib.component.git_diff())

  local TerminalBlock = {
    condition = function()
      return vim.bo.buftype == "terminal"
    end,

    update = "TermOpen",
  }

  local TerminalIcon = {
    provider = " ",
    hl = { fg = "green" },
  }

  local TerminalName = {
    provider = function()
      local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")

      return tname
    end,
  }

  TerminalBlock = utils.insert(TerminalBlock, TerminalIcon, TerminalName, Space)
  Left = utils.insert(Left, TerminalBlock)

  local HelpBlock = {
    condition = function()
      return vim.bo.filetype == "help"
    end,
  }

  local HelpIcon = {
    provider = " ",
    hl = { fg = "blue" },
  }

  local HelpFileName = {
    provider = function()
      local filename = vim.api.nvim_buf_get_name(0)

      return fn.fnamemodify(filename, ":t")
    end,
  }

  HelpBlock = utils.insert(HelpBlock, HelpIcon, HelpFileName)
  Left = utils.insert(Left, HelpBlock)

  local function rpad(child)
    return {
      condition = child.condition,
      child,
      Space,
    }
  end

  local function OverseerTasksForStatus(status)
    return {
      condition = function(self)
        return self.tasks[status]
      end,
      provider = function(self)
        return string.format("%s%d", self.symbols[status], #self.tasks[status])
      end,
      hl = function()
        return {
          fg = utils.get_highlight(string.format("Overseer%s", status)).fg,
        }
      end,
    }
  end

  local Overseer = {
    condition = function()
      return package.loaded.overseer
    end,
    init = function(self)
      local tasks = require("overseer.task_list").list_tasks({ unique = true })
      local tasks_by_status =
        require("overseer.util").tbl_group_by(tasks, "status")
      self.tasks = tasks_by_status
    end,
    static = {
      symbols = {
        ["CANCELED"] = " ",
        ["FAILURE"] = "󰅚 ",
        ["SUCCESS"] = "󰄴 ",
        ["RUNNING"] = "󰑮 ",
      },
    },

    rpad(OverseerTasksForStatus("CANCELED")),
    rpad(OverseerTasksForStatus("RUNNING")),
    rpad(OverseerTasksForStatus("SUCCESS")),
    rpad(OverseerTasksForStatus("FAILURE")),
  }

  Left = utils.insert(Left, Overseer)

  statusline = utils.insert(statusline, Left, Align)

  local Center = {}

  Center = utils.insert(Center, lib.component.cmd_info())

  local WorkDirIcon = {
    provider = " ",

    hl = { fg = "blue" },
  }

  local WorkDir = {
    init = function(self)
      self.indicator = (fn.haslocaldir(0) == 1 and "(Local)" or "") .. " "
      self.cwd = fn.fnamemodify(fn.getcwd(0), ":~")
    end,
    hl = { fg = "gray", bold = false },

    flexible = 1,

    {
      -- evaluates to the full-length path
      provider = function(self)
        local trail = self.cwd:sub(-1) == "/" and "" or "/"

        return self.indicator .. self.cwd .. trail .. " "
      end,
    },
    {
      -- evaluates to the shortened path
      provider = function(self)
        local cwd = fn.pathshorten(self.cwd)
        local trail = self.cwd:sub(-1) == "/" and "" or "/"

        return self.indicator .. cwd .. trail .. " "
      end,
    },
    {
      -- evaluates to "", hiding the component
      provider = "",
    },
  }

  Center = utils.insert(Center, WorkDirIcon, WorkDir)

  Center = utils.insert(Center, lib.component.virtual_env())

  statusline = utils.insert(statusline, Center, Align)

  local Right = {}

  Right = utils.insert(Right, lib.component.compiler_state(), Space, Separator)

  local LSPActive = {
    condition = function()
      return not conditions.buffer_matches({
        buftype = { "nofile", "quickfix", "help", "terminal", "prompt" },
      })
    end,

    provider = function()
      local ok, copilot = pcall(require, "copilot_status")

      if ok then
        return copilot.status_string()
      end

      return ""
    end,

    on_click = {
      callback = function()
        vim.defer_fn(function()
          vim.cmd("LspInfo")
        end, 100)
      end,
      name = "heirline_lspinfo",
    },

    hl = function()
      if conditions.lsp_attached() then
        return { fg = "text", bg = "mantle" }
      end

      return { fg = "surface1", bg = "mantle" }
    end,
  }

  Right = utils.insert(Right, LSPActive)

  local DAPMessages = {
    condition = function()
      local session = require("dap").session()

      return session ~= nil
    end,

    Separator,

    {
      provider = function()
        return " " .. require("dap").status() .. " "
      end,

      hl = "Debug",
    },
  }

  Right = utils.insert(Right, DAPMessages)

  local IndentBlock = {
    init = function(self)
      self.use_spaces = vim.bo.expandtab
      self.indent_size = vim.bo.tabstop
    end,

    update = "OptionSet",

    condition = function()
      return vim.bo.buftype == ""
    end,
  }

  local IndentIcon = {
    provider = "󰉶 ",

    hl = { fg = "green" },
  }

  local IndentIndicator = {
    {
      provider = function(self)
        return self.indent_size .. " "
      end,
    },
    {
      provider = function(self)
        return self.use_spaces and "SPC" or "TAB"
      end,

      hl = function(self)
        return {
          fg = self.use_spaces and "green" or "red",
        }
      end,
    },
  }

  IndentBlock =
    utils.insert(IndentBlock, Separator, IndentIcon, IndentIndicator)
  Right = utils.insert(Right, IndentBlock)

  local FileSize = {
    init = function(self)
      local size = fn.getfsize(vim.api.nvim_buf_get_name(0))

      self.fsize = fsize.bi_fsize(size)
    end,

    condition = function()
      return vim.bo.buftype == ""
    end,

    Separator,
    {
      provider = function(self)
        return self.fsize.size
      end,
    },
    {
      provider = function(self)
        return self.fsize.postfix
      end,

      hl = { fg = "surface1" },
    },
  }

  Right = utils.insert(
    Right,
    FileSize,
    lib.component.file_encoding({
      file_format = false,
    })
  )

  local Ruler = {
    update = { "CursorMoved", "TextChanged" },

    {
      provider = " ",

      hl = { fg = "surface1" },
    },
    {
      provider = "%2c",
    },
    {
      provider = ", ",

      hl = { fg = "surface1" },
    },
    {
      provider = "%3L",
    },
    {
      provider = "LOC",

      hl = { fg = "surface1" },
    },
    {
      provider = ", ",

      hl = { fg = "surface1" },
    },
    {
      provider = "%3p",
    },
    {
      provider = "%%",

      hl = { fg = "surface1" },
    },
  }

  Right = utils.insert(Right, Separator, Ruler)

  local ScrollBar = {
    static = {
      segments = { "▁", "▂", "▃", "▄", "▅", "▆", "▇", "█" },
    },

    update = "CursorMoved",

    provider = function(self)
      local current_lnum = vim.api.nvim_win_get_cursor(0)[1]
      local total_lines = vim.api.nvim_buf_line_count(0)
      local i = math.floor((current_lnum - 1) / total_lines * #self.segments)
        + 1

      return self.segments[i]:rep(2)
    end,

    hl = { fg = "green", bg = "bright_bg" },
  }

  statusline = utils.insert(statusline, Right, Space, ScrollBar)

  heirline.setup({
    statusline = statusline,
  })
end

return M
