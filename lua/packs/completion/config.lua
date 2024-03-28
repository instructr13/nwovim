local M = {}

function M.cmp_opts()
  local cmp = require("cmp")
  local types = require("cmp.types")
  local utils_str = require("cmp.utils.str")

  local luasnip = require("luasnip")

  local kind = require("constants.lsp.kind")

  local window_config = cmp.config.window.bordered({
    border = "rounded",
  })

  vim.api.nvim_set_hl(
    0,
    "CmpItemMenu",
    { fg = "#595D70", bg = "NONE", italic = true }
  )

  window_config.col_offset = -4

  local function has_words_before()
    if vim.bo.buftype == "prompt" then
      return false
    end

    local line, col = unpack(vim.api.nvim_win_get_cursor(0))

    return col ~= 0
      and vim.api
          .nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]
          :match("^%s*$")
        == nil
  end

  cmp.setup.filetype("markdown", {
    sources = cmp.config.sources({
      { name = "emoji" },
    }, {
      { name = "buffer", keyword_length = 3 },
    }),
  })

  cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources({
      { name = "git" },
    }, {
      { name = "buffer", keyword_length = 3 },
    }),
  })

  cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
    sources = {
      { name = "dap" },
    },
  })

  local cmdline_mapping = cmp.mapping.preset.cmdline({
    ["<Tab>"] = {
      c = function(_)
        if cmp.visible() then
          if #cmp.get_entries() == 1 then
            cmp.confirm({ select = true })
          else
            cmp.select_next_item()
          end
        else
          cmp.complete()
          if #cmp.get_entries() == 1 then
            cmp.confirm({ select = true })
          end
        end
      end,
    },
    ["<CR>"] = cmp.mapping(function(fallback)
      if cmp.visible() and cmp.get_active_entry() then
        cmp.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = false,
        })
      else
        fallback()
      end
    end, { "c" }),
  })

  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmdline_mapping,
    sources = cmp.config.sources({
      { name = "nvim_lsp_document_symbol" },
    }, {
      { name = "buffer", keyword_length = 3 },
    }),
    view = {
      entries = { name = "wildmenu", separator = " │ " },
    },
  })

  cmp.setup.cmdline(":", {
    enabled = function()
      local disabled = {
        IncRename = true,
      }

      local cmd = vim.fn.getcmdline():match("eS+")

      return not disabled[cmd] or cmp.close()
    end,
    mapping = cmdline_mapping,
    sources = cmp.config.sources({
      {
        name = "async_path",
      },
    }, {
      { name = "cmdline" },
      option = {
        ignore_cmds = { "e", "edit", "!", "Man" },
      },
    }),
  })

  return {
    enabled = function()
      return vim.bo.buftype ~= "prompt" or require("cmp_dap").is_dap_buffer()
    end,
    confirm_opts = {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    window = {
      completion = {
        col_offset = -3,
        side_padding = 0,
      },
      documentation = window_config,
    },
    sorting = {
      priority_weight = 2,
      comparators = {
        function(entry1, entry2)
          if vim.bo.buftype == "nofile" then
            return false
          end

          return require("copilot_cmp.comparators").prioritize(entry1, entry2)
        end,
        cmp.config.compare.offset,
        cmp.config.compare.exact,
        cmp.config.compare.score,
        require("cmp-under-comparator").under,
        cmp.config.compare.recently_used,
        cmp.config.compare.kind,
        cmp.config.compare.sort_text,
        cmp.config.compare.length,
        cmp.config.compare.order,
      },
    },
    -- Make completion menu similar to VS Code
    formatting = {
      fields = {
        cmp.ItemField.Kind,
        cmp.ItemField.Abbr,
        cmp.ItemField.Menu,
      },
      format = function(entry, vim_item)
        local kind_text = vim_item.kind

        vim_item.kind = kind[vim_item.kind] or vim_item.kind

        if entry:get_completion_item().detail == "Emmet Abbreviation" then
          vim_item.kind = " "
        end

        if vim.tbl_contains({ "path", "async_path" }, entry.source.name) then
          local icon, hl_group = require("nvim-web-devicons").get_icon(
            entry:get_completion_item().label
          )

          if icon then
            vim_item.kind = " " .. icon
            vim_item.kind_hl_group = hl_group

            return vim_item
          end
        end

        vim_item.menu = "    " .. kind_text

        if
          entry.completion_item.detail ~= nil
          and entry.completion_item.detail ~= ""
        then
          vim_item.menu = "    " .. entry.completion_item.detail
        end

        -- Code from max397574/ignis-nvim
        local word = entry:get_insert_text()
        local item = entry.completion_item

        word = utils_str.oneline(word)

        local max = 50

        if word:len() >= max then
          local before = word:sub(1, math.floor((max - 3) / 2))

          word = before .. "..."
        end

        if
          item.insertTextFormat == types.lsp.InsertTextFormat.Snippet
          and vim_item.abbr:sub(-1, -1) == "~"
        then
          word = word .. "~"
        end

        vim_item.abbr = word
        vim_item.kind = " " .. vim_item.kind

        return vim_item
      end,
    },
    mapping = {
      ["<Down>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<Up>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<CR>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          local opts = {}

          local function is_insert_mode()
            return vim.api.nvim_get_mode().mode:sub(1, 1) == "i"
          end

          if is_insert_mode() then
            opts.behavior = cmp.ConfirmBehavior.Insert
          end

          local entry = cmp.get_selected_entry()

          if entry and entry.source.name == "copilot" then
            opts.behavior = cmp.ConfirmBehavior.Replace
            opts.select = true
          end

          if cmp.confirm(opts) then
            return
          end
        end

        fallback()
      end),
    },
    sources = cmp.config.sources({
      { name = "copilot", group_index = 2 },
      { name = "nvim_lsp", group_index = 2 },
      { name = "luasnip", group_index = 2 },
    }, {
      { name = "async_path" },
      { name = "buffer", keyword_length = 3 },
    }),
    experimental = {
      ghost_text = true,
    },
  }
end

return M
