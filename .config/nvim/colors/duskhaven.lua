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
  Cursor = { fg = colors.bg, bg = colors.orange },
  CursorLineNr = { fg = colors.yellow, bold = true },
  Keyword = { fg = colors.yellow },
  String = { fg = colors.yellow },
  EndOfBuffer = { fg = colors.fg, bg = colors.bg },
  Function = { fg = colors.blue },
  Macro = { fg = colors.magenta },
  Type = { fg = colors.blue_light },
  Constant = { fg = colors.peach },
  Title = { fg = colors.orange, bold = true },
  NonText = { fg = colors.gray_dark },
  Special = { fg = colors.magenta },

  -- UI Elements
  Visual = { bg = colors.gray_darker },
  CursorLine = { bg = colors.bg_light },
  Search = { fg = colors.bg, bg = colors.yellow },
  IncSearch = { fg = colors.bg, bg = colors.orange },

  -- Statusline / Tabline
  StatusLine = { fg = colors.fg_dim, bg = colors.bg_dark },
  StatusLineNC = { fg = colors.gray, bg = colors.bg_dark },
  TabLine = { fg = colors.gray, bg = colors.bg_dark },
  TabLineSel = { fg = colors.fg, bg = colors.bg_light, bold = true },
  TabLineFill = { bg = colors.bg_dark },

  -- Diagnostics
  DiagnosticError = { fg = colors.red },
  DiagnosticWarn = { fg = colors.yellow },
  DiagnosticInfo = { fg = colors.cream },
  DiagnosticHint = { fg = colors.peach },

  -- Spelling
  SpellBad = { undercurl = true, sp = colors.red },
  SpellRare = { undercurl = true, sp = colors.magenta },
  SpellCap = { undercurl = true, sp = colors.blue_light },

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

  BlinkCmpLabel = { fg = colors.fg },
  BlinkCmpLabelMatch = { fg = colors.blue_light, bold = true },
  BlinkCmpLabelDetail = { fg = colors.fg_dim },

  BlinkCmpMenu = { fg = colors.fg, bg = colors.bg_dark },
  BlinkCmpMenuSelection = { fg = colors.fg, bg = colors.bg_light, bold = true },

  BlinkCmpKind = { fg = colors.blue },
  BlinkCmpKindMethod = { fg = colors.blue },
  BlinkCmpKindFunction = { fg = colors.blue },
  BlinkCmpKindConstructor = { fg = colors.blue },
  BlinkCmpKindClass = { fg = colors.blue_light },
  BlinkCmpKindInterface = { fg = colors.blue_light },
  BlinkCmpKindStruct = { fg = colors.blue_light },
  BlinkCmpKindModule = { fg = colors.blue_dark },
  BlinkCmpKindVariable = { fg = colors.orange },
  BlinkCmpKindProperty = { fg = colors.orange },
  BlinkCmpKindField = { fg = colors.orange },
  BlinkCmpKindConstant = { fg = colors.peach },
  BlinkCmpKindEnum = { fg = colors.yellow },
  BlinkCmpKindEnumMember = { fg = colors.yellow },
  BlinkCmpKindSnippet = { fg = colors.magenta },
  BlinkCmpKindKeyword = { fg = colors.yellow },
  BlinkCmpKindText = { fg = colors.fg_dim },

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
  ["@operator"] = { fg = colors.magenta },
  ["@tag"] = { fg = colors.blue_light },
  ["@tag.attribute"] = { fg = colors.peach },
  ["@tag.delimiter"] = { fg = colors.magenta },

  -- NeoTree
  NeoTreeDirectoryName = { fg = colors.yellow },
  NeoTreeFileName = { fg = colors.orange },
  NeoTreeFileNameOpened = { fg = colors.fg },
  NeoTreeDotfile = { fg = colors.gray },
  NeoTreeRootName = { fg = colors.magenta },
  NeoTreeFloatBorder = { fg = colors.orange },
  NeoTreeWinSeparator = { fg = colors.orange },
  NeoTreeIndentMarker = { fg = colors.magenta },
  NeoTreeExpander = { fg = colors.magenta },

  NeoTreeGitAdded = { fg = colors.green },
  NeoTreeGitUntracked = { fg = colors.green, italic = true },
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

  -- WhichKey
  WhichKey = { fg = colors.yellow },
  WhichKeyGroup = { fg = colors.blue_light },
  WhichKeyDesc = { fg = colors.fg_dim },
  WhichKeySeparator = { fg = colors.gray },

  -- Git signs
  GitSignsAdd = { fg = colors.green },
  GitSignsChange = { fg = colors.cream },
  GitSignsDelete = { fg = colors.red },
  GitSignsUntracked = { fg = colors.gray },

  -- Telescope
  TelescopeNormal = { fg = colors.fg, bg = colors.bg_dark },
  TelescopeBorder = { fg = colors.blue_light, bg = colors.bg_dark },
  TelescopePromptNormal = { fg = colors.fg, bg = colors.bg_light },
  TelescopePromptBorder = { fg = colors.orange, bg = colors.bg_light },
  TelescopeSelection = { fg = colors.fg, bg = colors.bg_light, bold = true },
  TelescopeMatching = { fg = colors.blue_light, bold = true },
}

-- Apply highlights
for group, opts in pairs(highlights) do
  vim.api.nvim_set_hl(0, group, opts)
end
