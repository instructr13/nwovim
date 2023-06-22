local M = {}

-- Code from https://github.com/NormalNvim/NormalNvim/blob/main/lua/base/3-autocmds.lua
function M.alpha_setup()
  vim.api.nvim_create_autocmd({ "User", "BufEnter" }, {
    desc = "Disable status and tablines for alpha",
    group = vim.api.nvim_create_augroup("alpha_setup", { clear = true }),
    callback = function(event)
      if
        (
          (event.event == "User" and event.file == "AlphaReady")
          or (
            event.event == "BufEnter"
            and vim.api.nvim_get_option_value("filetype", { buf = event.buf })
              == "alpha"
          )
        ) and not vim.g.before_alpha
      then
        vim.g.before_alpha = {
          showtabline = vim.opt.showtabline:get(),
          laststatus = vim.opt.laststatus:get(),
        }

        vim.opt.showtabline, vim.opt.laststatus = 0, 0
      elseif
        vim.g.before_alpha
        and event.event == "BufEnter"
        and vim.api.nvim_get_option_value("buftype", { buf = event.buf })
          ~= "nofile"
      then
        vim.opt.laststatus, vim.opt.showtabline =
          vim.g.before_alpha.laststatus, vim.g.before_alpha.showtabline

        vim.g.before_alpha = nil
      end
    end,
  })

  vim.api.nvim_create_autocmd("VimEnter", {
    desc = "Start Alpha when vim is opened with no arguments",
    group = vim.api.nvim_create_augroup("alpha_autostart", { clear = true }),
    callback = function()
      local should_skip = false

      if
        vim.fn.argc() > 0
        or vim.fn.line2byte(vim.fn.line("$")) ~= -1
        or not vim.o.modifiable
      then
        require("statuscol") -- Load statuscol.nvim
        require("fileline") -- Load fileline.nvim

        should_skip = true
      else
        for _, arg in pairs(vim.v.argv) do
          if
            arg == "-b"
            or arg == "-c"
            or vim.startswith(arg, "+")
            or arg == "-S"
          then
            should_skip = true

            break
          end
        end
      end

      if not should_skip then
        vim.api.nvim_create_autocmd({ "BufEnter" }, {
          group = vim.api.nvim_create_augroup(
            "statuscol_init",
            { clear = true }
          ),
          callback = function(opts)
            if vim.bo[opts.buf].buftype ~= "" then
              return
            end

            require("statuscol") -- Load statuscol.nvim
            vim.opt_local.statuscolumn = "%!v:lua.StatusCol()"

            vim.api.nvim_del_augroup_by_name("statuscol_init")
          end,
        })

        require("alpha").start(true, require("alpha").default_config)
      end
    end,
  })
end

function M.matchup_setup()
  vim.g.matchup_matchparen_offscreen = {
    method = "scrolloff",
  }

  vim.g.matchup_matchparen_defferred = 1
end

function M.spider_setup()
  local keymap = require("utils.keymap").omit("append", { "n", "o", "x" }, "")

  keymap("w", function()
    require("spider").motion("w")
  end, "Spider-w")

  keymap("e", function()
    require("spider").motion("e")
  end, "Spider-e")

  keymap("b", function()
    require("spider").motion("b")
  end, "Spider-b")

  keymap("ge", function()
    require("spider").motion("ge")
  end, "Spider-ge")
end

return M
