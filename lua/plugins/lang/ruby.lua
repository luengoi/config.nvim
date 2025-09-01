-- plugins.lang.ruby
-- Ruby language support.

return {
  -- LSP support.
  {
    "neovim/nvim-lspconfig",
		opts = {
      servers = {
        ruby_lsp = {},
        rubocop = {},
      },
    },
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "ruby" },
    },
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ruby = { "rubocop" },
      },
    },
  },
}
