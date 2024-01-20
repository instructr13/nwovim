return {
  {
    "delphinus/skkeleton_indicator.nvim",

    event = "ModeChanged",

    opts = {
      eijiHlName = "LineNr",
      hiraHlName = "String",
      kataHlName = "Todo",
      hankataHlName = "Special",
      zenkakuHlName = "LineNr",
      abbrevHlName = "Error",
      alwaysShown = false,
    },

    dependencies = {
      "vim-skk/skkeleton",

      init = function()
        local keymap = require("utils.keymap").keymap

        keymap(
          { "i", "c", "t" },
          "<C-j>",
          "<Plug>(skkeleton-enable)",
          { noremap = false }
        )
      end,

      config = function()
        local Path = require("plenary.path")

        vim.fn["skkeleton#config"]({
          eggLikeNewline = true,
          keepState = true,
          userDictionary = Path:new(require("constants.paths").data_dir)
            :joinpath("skkeleton")
            :absolute(),
        })
      end,

      dependencies = {
        "denops.vim",
      },
    },
  },
}
