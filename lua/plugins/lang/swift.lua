-- plugins.lang.swift
-- Swift language support.

return {
  -- LSP support
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        sourcekit = {
          -- sourcekit comes bundled with swift toolchain (cannot be installed with Mason).
          mason = false,
        },
      },
    },
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "swift" },
    },
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        swift = { "swift" },
      },
    },
  },

  -- Linting
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        swift = { "swiftlint" },
      },
    },
  },

  -- Testing
  {
    "nvim-neotest/neotest",
    dependencies = {
      { "mmllr/neotest-swift-testing", config = function() end },
    },
    opts = function(_, opts)
      local ret = vim.deepcopy(opts)
      ret.adapters = vim.tbl_extend("force", opts.adapters or {}, { require("neotest-swift-testing") })
      return ret
    end,
  },
}
