local C = require("packs.fold.config")

return {
  {
    "kevinhwang91/nvim-ufo",

    event = { "User NormalFile" },

    dependencies = {
      "kevinhwang91/promise-async",
    },

    opts = {
      preview = {
        win_config = {
          border = require("utils.border").get_border_chars("rounded"),
          winblend = 0,
        },
      },
      close_fold_kinds = { "comment", "imports" },
      fold_virt_text_handler = function(
        virtual_text,
        lnum,
        endlnum,
        width,
        truncate
      )
        local new_virtual_text = {}
        local foldlnum = endlnum - lnum
        local suffix = (" %s %d lines"):format("", foldlnum)
        local suffix_width = vim.fn.strdisplaywidth(suffix)
        local target_width = width - suffix_width
        local cursor_width = 0

        for _, chunk in ipairs(virtual_text) do
          local chunk_text = chunk[1]
          local chunk_width = vim.fn.strdisplaywidth(chunk_text)

          if target_width > cursor_width + chunk_width then
            table.insert(new_virtual_text, chunk)
          else
            chunk_text = truncate(chunk_text, target_width - cursor_width)

            local hl_group = chunk[2]

            table.insert(new_virtual_text, {
              chunk_text,
              hl_group,
            })

            chunk_width = vim.fn.strdisplaywidth(chunk_text)

            if cursor_width + chunk_width < target_width then
              suffix = suffix
                  .. (" "):rep(target_width - cursor_width - chunk_width)
            end

            break
          end

          cursor_width = cursor_width + chunk_width
        end

        table.insert(new_virtual_text, {
          suffix,
          "UfoFoldedEllipsis",
        })

        return new_virtual_text
      end,
    },
  },
  {
    "jghauser/fold-cycle.nvim",

    lazy = true,

    init = function()
      C.fold_cycle()
    end,

    opts = {},
  },
}
