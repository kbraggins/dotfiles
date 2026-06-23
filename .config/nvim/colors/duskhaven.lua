vim.g.colors_name = "duskhaven"

-- Clear previous highlights first
vim.cmd([[hi clear]])
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

local colors = require("duskhaven.palette")

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
  Macro = { fg = colors.magenta },
  Type = { fg = colors.blue_light },
  Constant = { fg = colors.peach },

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

  -- Completion Menu (Pmenu + Cmp + Blink)
  Pmenu = { fg = colors.fg, bg = colors.bg_dark },
  PmenuSel = { fg = colors.fg, bg = colors.bg_light, bold = true },
  PmenuBorder = { fg = colors.blue_light, bg = colors.bg_dark },
  PmenuThumb = { bg = colors.gray_dark },
  FloatBorder = { fg = colors.blue_light, bg = colors.bg_dark },

  CmpItemAbbr = { fg = colors.fg },
  CmpItemAbbrDeprecated = { fg = colors.gray, strikethrough = true },
  CmpItemAbbrMatch = { fg = colors.blue_light, bold = true },
  CmpItemAbbrMatchFuzzy = { fg = colors.blue_light, bold = true },

  CmpItemKind = { fg = colors.blue },
  CmpItemMenu = { fg = colors.fg_dim },

  CmpItemKindMethod = { fg = colors.blue },
  CmpItemKindFunction = { fg = colors.blue },
  CmpItemKindConstructor = { fg = colors.blue },
  CmpItemKindClass = { fg = colors.blue_light },
  CmpItemKindInterface = { fg = colors.blue_light },
  CmpItemKindStruct = { fg = colors.blue_light },
  CmpItemKindModule = { fg = colors.blue_dark },
  CmpItemKindVariable = { fg = colors.orange },
  CmpItemKindProperty = { fg = colors.orange },
  CmpItemKindField = { fg = colors.orange },
  CmpItemKindConstant = { fg = colors.peach },
  CmpItemKindEnum = { fg = colors.yellow },
  CmpItemKindEnumMember = { fg = colors.yellow },
  CmpItemKindSnippet = { fg = colors.magenta },
  CmpItemKindKeyword = { fg = colors.yellow },
  CmpItemKindText = { fg = colors.fg_dim },
  CmpGhostText = { fg = colors.gray, italic = true },

  -- Blink.cmp
  BlinkCmpLabel = { fg = colors.fg },
  BlinkCmpLabelMatch = { fg = colors.blue_light, bold = true },
  BlinkCmpLabelDetail = { fg = colors.fg_dim },
  BlinkCmpKind = { fg = colors.blue },
  BlinkCmpMenu = { fg = colors.fg_dim },
  BlinkCmpKindFunction = { fg = colors.blue },
  BlinkCmpKindMethod = { fg = colors.blue },
  BlinkCmpKindClass = { fg = colors.blue_light },
  BlinkCmpKindModule = { fg = colors.blue_dark },
  BlinkCmpKindVariable = { fg = colors.orange },

  -- Treesitter
  ["@variable"] = { fg = colors.orange },
  ["@keyword"] = { fg = colors.yellow },
  ["@type"] = { fg = colors.blue_light },
  ["@type.builtin"] = { fg = colors.yellow },
  ["@function"] = { fg = colors.blue },
  ["@string"] = { fg = colors.yellow },
  ["@punctuation"] = { fg = colors.magenta },
  ["@constant"] = { fg = colors.peach },
  ["@constant.macro"] = { fg = colors.magenta },

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
