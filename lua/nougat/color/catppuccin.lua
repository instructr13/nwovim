local M = {}

function M.get()
  local palette = require("catppuccin.palettes").get_palette()

  if palette == nil then
    error("Palette not found")

    return
  end

  return {
    red = palette.red,
    green = palette.green,
    yellow = palette.yellow,
    blue = palette.blue,
    magenta = palette.mauve,
    cyan = palette.sky,

    bg = palette.crust,
    fg = palette.text,

    bg0 = palette.surface0,
    bg1 = palette.surface1,
    bg2 = palette.surface2,
    bg3 = palette.overlay0,
    bg4 = palette.overlay1,

    fg0 = palette.text,
    fg1 = palette.subtext0,
    fg2 = palette.subtext1,
    fg3 = palette.overlay1,
    fg4 = palette.overlay2,

    accent = {
      red = palette.maroon,
      green = palette.teal,
      yellow = palette.peach,
      blue = palette.lavender,
      magenta = palette.pink,
      cyan = palette.sapphire,

      bg = palette.mantle,
      fg = palette.subtext0,
    },
  }
end

return M
