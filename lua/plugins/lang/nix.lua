return {
  -- LSP support
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        nixd = {
          mason = false,
        },
      },
    },
  },

  -- formatting and syntax
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "nix",
      },
    },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        nix = { "nixfmt" },
      },
    },
  },
}
