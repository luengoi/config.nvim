-- This file is automatically loaded before lazy.vim startup.

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("custom-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
