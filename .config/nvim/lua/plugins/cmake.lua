return {
  "Civitasv/cmake-tools.nvim",
  opts = {
    cmake_build_directory = "build", -- Ensure build directory is 'build'
    cmake_compile_commands_options = {
      action = "none", -- Disables symlink compile_commands.json in root directory
    },
  },
}
