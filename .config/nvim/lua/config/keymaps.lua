-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- CMake keybinds
vim.api.nvim_set_keymap("n", "<leader>cr", ":CMakeRun<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ce", ":CMakeStopRunner<CR>", { noremap = true, silent = true })
