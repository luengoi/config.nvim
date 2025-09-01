-- plugins.coding
-- Plugins to enhance coding experience.

return {
  -- Completion.
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      signature = {
        enabled = true,
        window = {
          border = "rounded",
        },
      },
      completion = {
        menu = {
          border = "rounded",
        },
        documentation = {
          window = {
            border = "rounded",
          },
        },
      },
      keymap = {
        preset = "default",
        ["<C-k>"] = { "show_documentation", "hide_documentation", "fallback" },
      },
    },
  },

  -- Better textobjects (around/inside).
  {
    "echasnovski/mini.ai",
    version = false,
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ -- function
            a = "@function.outer",
            i = "@function.inner"
          }),
          c = ai.gen_spec.treesitter({ -- class
            a = "@class.outer",
            i = "@class.inner",
          }),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
        },
      }
    end,
  },

  -- Better surroundings.
  {
    "echasnovski/mini.surround",
    version = false,
    event = "VeryLazy",
    config = true,
  },
}
