return {
  -- LSP support
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {},
      },
    },
  },

  -- tooling
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "shellcheck",
        "shfmt",
      },
    },
  },

  -- formatting and syntax
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
      },
    },
  },

  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        sh = { "shfmt" },
        bash = { "shfmt" },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        sh = { "shellcheck" },
        bash = { "shellcheck" },
      },
    },
  },
}
