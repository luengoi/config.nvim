-- plugins.treesitter
-- Treesitter configuration.

return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    branch = "main",
    build = ":TSUpdate",
    opts_extend = { "ensure_installed" },
    ---@type TSConfig
    opts = {
      ensure_installed = {
        "awk",
        "bash",
        "cmake",
        "css",
        "csv",
        "editorconfig",
        "git_config",
        "git_rebase",
        "gitcommit",
        "gitignore",
        "html",
        "hyprlang",
        "jq",
        "json",
        "kdl",
        "latex",
        "lua",
        "luadoc",
        "make",
        "markdown",
        "markdown_iniline",
        "nix",
        "query",
        "regex",
        "scss",
        "ssh_config",
        "tmux",
        "toml",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
    },
    config = function(_, opts)
      local treesitter = require("nvim-treesitter")
      treesitter.setup(opts)
      treesitter.install(opts.ensure_installed)
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
  },
}
