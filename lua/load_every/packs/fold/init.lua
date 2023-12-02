local C = require("packs.fold.config")

return {
  {
    "jghauser/fold-cycle.nvim",

    lazy = true,

    init = function()
      C.fold_cycle()
    end,

    opts = {},
  },
}
