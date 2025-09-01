-- config.keymaps
-- These keymaps will be loaded before plugins.

-- Clear search highlights
vim.keymap.set("n", "<esc>", "<cmd>noh<cr>", { desc = "Clear search highlights" })

-- Commenting
vim.keymap.set("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add comment below" })
vim.keymap.set("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add comment above" })
