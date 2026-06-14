vim.g.colors_name = "duskhaven"

-- Clear previous highlights first
vim.cmd([[hi clear]])
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

local colors = {
  bg = "#0c1021",
  bg_light = "#1a1f35",
  bg_dark = "#0a0d1a",
  fg = "#fdfff1",
  fg_dim = "#d8d9c8",

  orange = "#f25e01",
  yellow = "#b3f63a",
  magenta = "#ff0cac",
  blue = "#6b8ab8",
  blue_light = "#97c7e9",
  blue_dark = "#314d8a",
  red = "#e04a5f",
  green = "#55ba30",
  peach = "#f5c6b0",
  cream = "#f8e9c7",
  gray = "#a4a7a7",
  gray_dark = "#505257",
  gray_darker = "#35384a",
  black = "#272822",
}

-- Highlight groups
local highlights = {
  Normal = { fg = colors.fg, bg = colors.bg },
  NormalFloat = { fg = colors.fg, bg = colors.bg_dark },
  Comment = { fg = colors.gray },
  LineNr = { fg = colors.yellow },
  CursorLineNr = { fg = colors.yellow, bold = true },
  Keyword = { fg = colors.yellow },
  String = { fg = colors.yellow },
  EndOfBuffer = { fg = colors.fg, bg = colors.bg },
  Function = { fg = colors.blue },

  -- UI Elements
  Visual = { bg = colors.gray_darker },
  CursorLine = { bg = colors.bg_light },
  Search = { fg = colors.bg, bg = colors.yellow },
  IncSearch = { fg = colors.bg, bg = colors.orange },

  -- Diagnostics
  DiagnosticError = { fg = colors.red },
  DiagnosticWarn = { fg = colors.yellow },
  DiagnosticInfo = { fg = colors.cream },
  DiagnosticHint = { fg = colors.peach },

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
  NeoTreeGitAdded = { fg = colors.green },
  NeoTreeGitModified = { fg = colors.cream },
  NeoTreeGitDeleted = { fg = colors.red },
  NeoTreeGitIgnored = { fg = colors.gray_dark },

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
