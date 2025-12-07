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
}
