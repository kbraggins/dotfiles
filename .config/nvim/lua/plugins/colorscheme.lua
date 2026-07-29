return {

  -- duskhaven.nvim
  {
    "kbraggins/duskhaven.nvim",
    dir = "~/dev/lua/duskhaven.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
    },
  },

  -- add gruvbox
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    opts = {
      contrast = "medium",
      transparent_mode = true,
    },
  },

  -- add catppuccin
  {
    "catppuccin/nvim",
    lazy = true,
    name = "catppuccin",
    opts = {
      transparent_background = true,
    },
  },

  -- add papercolor
  {
    "NLKNguyen/papercolor-theme",
    lazy = true,
    name = "papercolor",
  },

  -- add onedark
  {
    "navarasu/onedark.nvim",
    lazy = true,
    opts = {
      style = "dark",
    },
  },

  -- add kanagawa
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    opts = {},
  },

  -- Configure LazyVim to load colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "duskhaven",
    },
  },
}
