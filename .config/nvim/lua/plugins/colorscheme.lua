return {
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

  -- add monokai pro
  {
    "loctvl842/monokai-pro.nvim",
    lazy = false,
    opts = {
      transparent_background = true,
    },
    -- Custom settings for monokai pro setup
    -- This applies the classic filter along with changing the bg color
    -- config = function()
    --   require("monokai-pro").set_filter("classic")
    --   require("monokai-pro").setup({
    --     override_palette = function(filter)
    --       return {
    --         background = "#2d2a2e",
    --       }
    --     end,
    --   })
    -- end,
  },

  -- Configure LazyVim to load colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "duskhaven",
    },
  },
}
