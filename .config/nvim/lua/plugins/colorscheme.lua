return {

  -- Configure LazyVim to load colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "duskhaven",
    },
  },

  -- duskhaven.nvim
  {
    "kbraggins/duskhaven.nvim",
    dev = true, -- local checkout in ~/dev/lua when present (see dev in lua/config/lazy.lua)
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
    },
  },

  -- gruvbox
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    opts = {
      contrast = "medium",
      transparent_mode = true,
    },
  },

  -- catppuccin
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      transparent_background = true,
    },
  },

  -- papercolor
  {
    "NLKNguyen/papercolor-theme",
    lazy = true,
    name = "papercolor",
  },

  -- onedark
  {
    "navarasu/onedark.nvim",
    lazy = true,
    opts = {
      style = "dark",
    },
  },

  -- kanagawa
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = {},
  },
}
