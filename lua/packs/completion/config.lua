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

  window_config.col_offset = -5

  -- Set highlight for the copilot kind icon
  vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

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

  cmp.setup.cmdline({ "/", "?" }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "nvim_lsp_document_symbol" },
    }, {
      { name = "buffer", keyword_length = 3 },
    }),
    view = {
      entries = { name = "wildmenu", separator = " │ " },
    },
  })

  cmp.setup.cmdline({ ":" }, {
    mapping = cmp.mapping.preset.cmdline({
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
    }),
    sources = cmp.config.sources({
      { name = "async_path" },
    }, {
      { name = "cmdline" },
    }),
  })

  return {
    enabled = function()
      return vim.bo.buftype ~= "prompt" or require("cmp_dap").is_dap_buffer()
    end,
    snippet = {
      expand = function(args)
        require("luasnip").lsp_expand(args.body)
      end,
    },
    window = {
      completion = window_config,
      documentation = window_config,
    },
    sorting = {
      priority_weight = 2,
      comparators = {
        require("copilot_cmp.comparators").prioritize,
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
        vim_item.kind = kind[vim_item.kind] or vim_item.kind

        -- Code from max397574/ignis-nvim
        local word = entry:get_insert_text()
        local item = entry.completion_item

        if item.insertTextFormat == types.lsp.InsertTextFormat.Snippet then
          word = vim.lsp.util.parse_snippet(word)
        end

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
        if cmp.visible() and has_words_before() then
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
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
      ["<CR>"] = cmp.mapping({
        i = function(fallback)
          if cmp.visible() and cmp.get_active_entry() then
            cmp.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = false,
            })
          else
            fallback()
          end
        end,
        s = cmp.mapping.confirm({ select = true }),
        c = cmp.mapping.confirm({
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        }),
      }),
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
