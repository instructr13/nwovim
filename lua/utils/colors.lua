local M = {}

-- Code from strash/everybody-wants-that-line.nvim

---Returns linearly interpolated number
---@param v number from 0.0 to 1.0
---@param a number
---@param b number
---@return number
local function lerp(v, a, b)
  v = math.max(math.min(v, 1), 0)

  if a and b then
    return (1.0 - v) * a + b * v
  else
    return b
  end
end

---@alias rgb integer[] each number from 0 to 255
---@alias hsb integer[] h 0-360, s 0-100, b 0-100
---@alias color_palette { hex: string, rgb: rgb, hsb: hsb }

---Convert hex to 8bit rgb color, e.g. `FFFFFF` -> `{ 255, 255, 255 }`
---@param hex string
---@return rgb
function M.hex_to_rgb(hex)
  return {
    tonumber(hex:sub(1, 2), 16),
    tonumber(hex:sub(3, 4), 16),
    tonumber(hex:sub(5, 6), 16),
  }
end

---Convert 8bit rgb to hex color, e.g. `{ 255, 255, 255 }` -> `FFFFFF`
---@param rgb rgb
---@return string
function M.rgb_to_hex(rgb)
  return table.concat({
    string.format("%02x", rgb[1]),
    string.format("%02x", rgb[2]),
    string.format("%02x", rgb[3]),
  }):upper()
end

---Blend colors between two color palettes
---@param intensity number from 0.0 to 1.0
---@param from color_palette
---@param to color_palette
---@return color_palette
function M.blend_colors(intensity, from, to)
  local rgb = {}

  for i = 1, 3 do
    local rgb_c = math.floor(lerp(intensity, from.rgb[i], to.rgb[i]))

    table.insert(rgb, rgb_c)
  end

  local hex = M.rgb_to_hex(rgb)
  local hsb = M.rgb_to_hsb(rgb)

  return { hex = hex, rgb = rgb, hsb = hsb }
end
