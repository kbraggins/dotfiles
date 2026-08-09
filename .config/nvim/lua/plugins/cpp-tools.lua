-- Generate out-of-class definitions from declarations in a .h,
-- the way Visual Studio / JetBrains do it.
return {
  "Badhi/nvim-treesitter-cpp-tools",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  ft = { "c", "cpp", "objc", "objcpp", "cuda" },
  config = function()
    require("nt-cpp-tools").setup({
      preview = {
        quit = "q", -- reject the generated snippet
        accept = "<tab>", -- insert it
      },
      header_extension = "h",
      source_extension = "cpp",
      -- The stock TSCppDefineClassFunc previews and inserts into the *current*
      -- buffer. This variant skips the preview and writes straight into the
      -- matching .cpp, which is the Visual Studio / JetBrains behaviour.
      custom_define_class_function_commands = {
        TSCppImplWrite = {
          output_handle = require("nt-cpp-tools.output_handlers").get_add_to_cpp(),
        },
      },
    })

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("cpp_tools_keymaps", { clear = true }),
      pattern = { "c", "cpp", "objc", "objcpp", "cuda" },
      callback = function(ev)
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
        end

        map({ "n", "v" }, "<leader>ci", "<cmd>TSCppImplWrite<cr>", "Implement Declarations -> .cpp")
        map({ "n", "v" }, "<leader>cI", "<cmd>TSCppDefineClassFunc<cr>", "Implement Declarations (preview, inline)")
        map({ "n", "v" }, "<leader>ce", "<cmd>TSCppMakeConcreteClass<cr>", "Implement Pure Virtuals")
        map("n", "<leader>c3", "<cmd>TSCppRuleOf3<cr>", "Rule of 3")
        map("n", "<leader>c5", "<cmd>TSCppRuleOf5<cr>", "Rule of 5")
      end,
    })
  end,
}
