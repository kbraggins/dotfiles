vim.g.colors_name = "duskfall"

-- Clear previous highlights first
vim.cmd([[hi clear]])
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

local colors = {
  bg = "#0c1021",
  fg = "#fdfff1",
  orange = "#f25e01",
  yellow = "#b3f63a",
  green = "#55ba30",
  blue = "#7c9ec8",
  blue_light = "#97c7e9",
  blue_dark = "#000098",
  red = "#f2011c",
  gray = "#a4a7a7",
  gray_dark = "#505257",
  magenta = "#ff0cff",
  white = "#fdfff1",
  cream = "#ffbfb9",
  black = "#272822",
}

-- Highlight groups
local highlights = {
  Normal = { fg = colors.fg, bg = colors.bg },
  Comment = { fg = colors.gray },
  LineNr = { fg = colors.yellow },
  Keyword = { fg = colors.orange },
  String = { fg = colors.yellow },
  EndOfBuffer = { fg = colors.fg, bg = colors.bg },
  Function = { fg = colors.blue },

  -- Treesitter
  ["@variable"] = { fg = colors.blue_light },
  ["@keyword"] = { fg = colors.yellow },
  ["@type"] = { fg = colors.orange },
  ["@function"] = { fg = colors.blue },
  ["@string"] = { fg = colors.yellow },
  ["@punctuation"] = { fg = colors.magenta },
}

-- Apply highlights
for group, opts in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, opts)
end
