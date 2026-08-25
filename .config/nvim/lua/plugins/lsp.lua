return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- The `lang.cmake` extra uses neocmakelsp. A stale `cmake-language-server`
      -- mason package is also still installed, and mason-lspconfig's
      -- `automatic_enable` starts every *installed* server -- so a second,
      -- redundant cmake LSP was launched on every cmake buffer, and its venv is
      -- broken, so all it ever produced was a spawn error. `enabled = false` puts
      -- it in mason-lspconfig's exclude list. (lspconfig calls this server
      -- `cmake`; the old name `cmakels` is no longer matched.)
      cmake = { enabled = false },
      clangd = {
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
          "--header-insertion=never",
        },
      },
    },
    setup = {
      clangd = function(_, opts)
        local clangd_ext_opts = require("lazyvim.util").opts("clangd_extensions.nvim")
        require("clangd_extensions").setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
        return false
      end,
    },
  },
}
