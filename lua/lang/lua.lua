return {
  -- LSP support
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
      },
    },
  },

  -- tooling
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "stylua" } },
  },

  -- formatting and syntax
  {
    "stevearc/conform.nvim",
    opts = { formatters_by_ft = { lua = { "stylua" } } },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "lua", "luadoc", "luap" } },
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    dependencies = { "Bilal2453/luvit-meta" },
    opts = {
      library = {
        path = { "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
}
