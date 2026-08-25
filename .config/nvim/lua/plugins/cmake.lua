return {
  {
    "Civitasv/cmake-tools.nvim",
    opts = {
      cmake_build_directory = "build", -- Ensure build directory is 'build'
      cmake_compile_commands_options = {
        action = "none", -- Disables symlink compile_commands.json in root directory
      },
    },
    -- `<leader>m` for "make" -- LazyVim leaves this prefix free.
    -- These also act as a load trigger, so the commands work even when nvim
    -- was opened from a subdirectory (the extra only auto-loads when
    -- CMakeLists.txt sits in the cwd).
    keys = {
      -- configure / build / run / debug
      { "<leader>mg", "<cmd>CMakeGenerate<cr>", desc = "Generate (configure)" },
      { "<leader>mb", "<cmd>CMakeBuild<cr>", desc = "Build" },
      { "<leader>mr", "<cmd>CMakeRun<cr>", desc = "Run" },
      { "<leader>md", "<cmd>CMakeDebug<cr>", desc = "Debug" },
      { "<leader>mq", "<cmd>CMakeQuickRun<cr>", desc = "Quick Run (generate+build+run)" },
      { "<leader>mt", "<cmd>CMakeRunTest<cr>", desc = "Run Tests (ctest)" },
      { "<leader>mc", "<cmd>CMakeClean<cr>", desc = "Clean" },
      { "<leader>mi", "<cmd>CMakeInstall<cr>", desc = "Install" },
      { "<leader>ma", "<cmd>CMakeLaunchArgs<cr>", desc = "Set Launch Args" },

      -- selection
      { "<leader>msb", "<cmd>CMakeSelectBuildTarget<cr>", desc = "Build Target" },
      { "<leader>msl", "<cmd>CMakeSelectLaunchTarget<cr>", desc = "Launch Target" },
      { "<leader>mst", "<cmd>CMakeSelectBuildType<cr>", desc = "Build Type" },
      { "<leader>msk", "<cmd>CMakeSelectKit<cr>", desc = "Kit" },
      { "<leader>msd", "<cmd>CMakeSelectBuildDir<cr>", desc = "Build Directory" },
      { "<leader>msc", "<cmd>CMakeSelectConfigurePreset<cr>", desc = "Configure Preset" },
      { "<leader>msp", "<cmd>CMakeSelectBuildPreset<cr>", desc = "Build Preset" },
      { "<leader>msT", "<cmd>CMakeSelectTestPreset<cr>", desc = "Test Preset" },

      -- output windows / stopping
      { "<leader>mo", "<cmd>CMakeOpenExecutor<cr>", desc = "Open Build Output" },
      { "<leader>mO", "<cmd>CMakeOpenRunner<cr>", desc = "Open Run Output" },
      { "<leader>mx", "<cmd>CMakeStopRunner<cr>", desc = "Stop Runner" },
      { "<leader>mX", "<cmd>CMakeStopExecutor<cr>", desc = "Stop Build" },
      { "<leader>mS", "<cmd>CMakeSettings<cr>", desc = "Show Settings" },
    },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        cmake = { "cmake_format" },
      },
    },
  },

  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      spec = {
        { "<leader>m", group = "cmake" },
        { "<leader>ms", group = "select" },
      },
    },
  },
}
