local M = {}

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
