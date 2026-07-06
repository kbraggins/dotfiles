return {

  -- duskhaven.nvim
  {
    "kbraggins/duskhaven.nvim",
    dir = "~/dev/lua/duskhaven.nvim",
    lazy = false,
  },

  -- add gruvbox
  {
    "ellisonleao/gruvbox.nvim",
    opts = {
      contrast = "medium",
      transparent_mode = true,
    },
  },

  -- add catppuccin
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    opts = {
      transparent_background = true,
    },
    -- Enable transparency on startup
    config = function(_, opts)
      -- apply colorscheme first
      vim.cmd.colorscheme(opts.colorscheme)

      -- then force transparency
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
      vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
    end,
  },

  -- add papercolor
  {
    "NLKNguyen/papercolor-theme",
    lazy = false,
    name = "papercolor",
  },

  -- add onedark
  {
    "navarasu/onedark.nvim",
    opts = {
      style = "dark",
    },
  },

  -- add kanagawa
  {
    "rebelot/kanagawa.nvim",
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
