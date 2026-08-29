return {
  -- `ensure_installed` is an `opts_extend` list, so every spec that wants a tool
  -- appends to it -- lazy.nvim concatenates, it never de-duplicates. Both the
  -- `lang.clangd` and `lang.rust` extras ask for "codelldb", so it lands in the
  -- list twice, and LazyVim's mason config just walks the list calling
  -- `p:install()`. The second call for a not-yet-installed package hits mason's
  -- `assert(not self:is_installing())` and the whole config errors out, which
  -- also means every tool after it in the list never gets installed.
  -- This runs last (user specs are imported after LazyVim's own), so it sees the
  -- fully merged list and collapses the duplicates.
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      local seen, unique = {}, {}
      for _, tool in ipairs(opts.ensure_installed or {}) do
        if not seen[tool] then
          seen[tool] = true
          unique[#unique + 1] = tool
        end
      end
      opts.ensure_installed = unique
    end,
  },

  -- Same `assert(not self:is_installing())`, different racer. With
  -- `automatic_installation`, mason-nvim-dap walks every registered dap adapter
  -- and installs the matching package if it isn't on disk yet -- but mason's own
  -- `ensure_installed` pass has already kicked off that download asynchronously
  -- (the `lang.clangd` extra registers the codelldb adapter *and* adds codelldb
  -- to `ensure_installed`). Opening a CMake file makes cmake-tools load nvim-dap
  -- mid-download, mason-nvim-dap calls `install()` on the in-flight package, and
  -- the assert blows up nvim-dap's config.
  -- Nothing is lost by turning it off: every LazyVim extra that registers an
  -- adapter also adds its package to `ensure_installed`, so mason installs them
  -- anyway -- just once, from one place.
  {
    "jay-babu/mason-nvim-dap.nvim",
    optional = true,
    opts = { automatic_installation = false },
  },
}
