return {
  "nvim-lualine/lualine.nvim",
  opts = {
    sections = {
      lualine_z = {
        { "datetime", style = "%I:%M %p" }, -- ← 12-hour + AM/PM
        -- Or if you prefer no leading zero and lowercase am/pm:
        -- { "datetime", style = "%l:%M %p" },
      },
    },
  },
  config = function(_, opts)
    require("lualine").setup(opts)

    -- 👇 force transparency AFTER lualine loads
    vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
    vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "none" })
  end,
}
