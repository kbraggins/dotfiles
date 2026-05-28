vim.g.colors_name = "duskhaven"

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
  blue_dark = "#314d8a",
  red = "#ba0f35",
  gray = "#a4a7a7",
  gray_dark = "#505257",
  magenta = "#ff0cac",
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
  ["@variable"] = { fg = colors.orange },
  ["@keyword"] = { fg = colors.yellow },
  ["@type"] = { fg = colors.blue_light },
  ["@function"] = { fg = colors.blue },
  ["@string"] = { fg = colors.yellow },
  ["@punctuation"] = { fg = colors.magenta },

  -- NeoTree
  NeoTreeDirectoryName = { fg = colors.yellow },
  NeoTreeFileName = { fg = colors.orange },
  NeoTreeFileNameOpened = { fg = colors.white },
  NeoTreeDotfile = { fg = colors.gray },
  NeoTreeRootName = { fg = colors.magenta },
  NeoTreeFloatBorder = { fg = colors.orange },
  NeoTreeWinSeparator = { fg = colors.orange },
  NeoTreeIndentMarker = { fg = colors.magenta },
  NeoTreeExpander = { fg = colors.magenta },

  -- Snacks.nvim
  SnacksDashboardHeader = { fg = colors.orange },
  SnacksDashboardIcon = { fg = colors.yellow },
  SnacksDashboardDesc = { fg = colors.orange },
  SnacksDashboardKey = { fg = colors.yellow },
  SnacksDashboardFooter = { fg = colors.yellow },
  SnacksDashboardSpecial = { fg = colors.magenta },
}

-- Apply highlights
for group, opts in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, opts)
end
