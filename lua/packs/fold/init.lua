return {
  {
    "kevinhwang91/nvim-ufo",

    event = { "User NormalFile" },

    dependencies = {
      "kevinhwang91/promise-async",
    },

    init = function()
      local keymap = require("utils.keymap").omit("append", { "n" }, "z")

      keymap("R", function()
        require("ufo").openAllFolds()
      end, "Open All Folds")

      keymap("M", function()
        require("ufo").closeAllFolds()
      end, "Close All Folds")

      keymap("r", function()
        require("ufo").openFoldsExceptKinds()
      end, "Open Folds Except Kinds")

      keymap("m", function()
        require("ufo").closeFoldsWith()
      end, "Close Current Fold Level")
    end,

    opts = {
      preview = {
        win_config = {
          border = require("utils.border").get_border_chars("rounded"),
          winblend = 0,
        },
      },
      close_fold_kinds_for_ft = {
        default = { "comment", "imports" },
        c = { "comment", "region" },
      },
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
}
