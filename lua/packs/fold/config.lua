local M = {}

function M.fold_cycle()
  local keymap =
      require("utils.keymap").omit("append", "n", "", { silent = true })

  keymap("<cr>", function()
    return require("fold-cycle").open()
  end, "Fold-cycle: open folds")

  keymap("<bs>", function()
    return require("fold-cycle").close()
  end, "Fold-cycle: close folds")

  require("utils.keymap").keymap("n", "zC", function()
    return require("fold-cycle").close_all()
  end, "Fold-cycle: close all folds", { remap = true, silent = true })
end

return M
