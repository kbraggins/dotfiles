return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    opts.ensure_installed = vim.tbl_extend("force", opts.ensure_installed or {}, {
      "lua",
      "tsx",
      "typescript",
      "rust",
      "cpp",
      "zig",
      "json",
      "markdown",
      "markdown_inline",
      "bash",
    })
  end,
}
