local M = {}

---@param c  string
local function rgb(c)
  c = string.lower(c)
  return { tonumber(c:sub(2, 3), 16), tonumber(c:sub(4, 5), 16), tonumber(c:sub(6, 7), 16) }
end

---@param foreground string foreground color
---@param background string background color
---@param alpha number|string number between 0 and 1. 0 results in bg, 1 results in fg
local function blend(foreground, background, alpha)
  alpha = type(alpha) == "string" and (tonumber(alpha, 16) / 0xff) or alpha
  local bg = rgb(background)
  local fg = rgb(foreground)

  local blendChannel = function(i)
    local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end

  return string.format("#%02x%02x%02x", blendChannel(1), blendChannel(2), blendChannel(3))
end

--- generate RenderMarkdown highlights table
-- @param colors color (theme) color table created by require("leaf.colors").setup()
-- @param config config options (optional)
function M.setup(c, opts)
  -- stylua: ignore
  local ret = {
    RenderMarkdownBullet     = { fg = c.blue0 }, -- horizontal rule
    RenderMarkdownCode       = { bg = c.code_bg },
    RenderMarkdownDash       = { fg = c.blue0 }, -- horizontal rule
    RenderMarkdownTableHead  = { fg = c.red0 },
    RenderMarkdownTableRow   = { fg = c.blue0 },
    RenderMarkdownCodeInline = { link = "@markup.raw.markdown_inline" }
  }
  local header_colors = {
    c.red0,
    c.orange0,
    c.yellow0,
    c.teal0,
    c.blue0,
    c.purple0
  }
  for i, color in ipairs(header_colors) do
    ret["RenderMarkdownH" .. i .. "Bg"] = { bg = blend(color, c.bg0, 0.1) }
    ret["RenderMarkdownH" .. i .. "Fg"] = { fg = color, bold = true }
  end
  return ret
end

return M
