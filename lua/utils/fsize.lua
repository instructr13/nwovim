local M = {}

-- Code by https://github.com/strash/everybody-wants-that-line.nvim/blob/main/lua/everybody-wants-that-line/utils/util.lua

---Returns rounded integer from `v`
---@param v number
---@return integer
function M.round(v)
  if tostring(v):find("%.") == nil then
    return math.floor(v)
  else
    local dec = tonumber(tostring(v):match("%.%d+"))
    if dec >= 0.5 then
      return math.ceil(v)
    else
      return math.floor(v)
    end
  end
end

function M.bi_fsize(size)
  size = size > 0 and size or 0

  -- bytes
  if size < 1024 then
    return { size = size, postfix = "B" }
    -- kibibytes
  elseif size >= 1024 and size <= 1024 * 1024 then
    return { size = M.round(size * 2 ^ -10 * 100) / 100, postfix = "KiB" }
  end

  -- mebibytes
  return { size = M.round(size * 2 ^ -20 * 100) / 100, postfix = "MiB" }
end

return M
