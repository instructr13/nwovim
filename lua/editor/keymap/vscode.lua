local keymap = require("utils.keymap").keymap

keymap({ "n", "o", "x" }, "gc", "<Plug>VSCodeCommentary", "Toggle comments")
keymap("n", "gcc", "<Plug>VSCodeCommentaryLine", "Toggle comments")
