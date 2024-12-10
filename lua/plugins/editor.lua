function _G.get_oil_winbar()
  local dir = require("oil").get_current_dir()
  if dir then
    return vim.fn.fnamemodify(dir, ":~")
  else
    return vim.api.nvim_buf_get_name(0)
  end
end

return {
  -- directory management
  {
    "stevearc/oil.nvim",
    keys = {
      { "-", "<cmd>Oil<cr>", desc = "Open parent directory in Oil" },
    },
    lazy = (function()
      local stats = vim.uv.fs_stat(vim.fn.argv(0))
      if stats and stats.type == "directory" then
        return false
      end
      return true
    end)(),
    ---@module "oil"
    ---@type oil.SetupOpts
    opts = {
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
      },
      win_options = {
        winbar = "%!v:lua.get_oil_winbar()",
      },
    },
  },

  -- fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    version = false,
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
    },
    keys = function()
      local builtin = require("telescope.builtin")

      return {
        { "<leader>sh", builtin.help_tags, desc = "[S]earch [H]elp" },
        { "<leader>sk", builtin.keymaps, desc = "[S]earch [K]eymaps" },
        { "<leader>sf", builtin.find_files, desc = "[S]earch [F]iles" },
        { "<leader>ss", builtin.builtin, desc = "[S]earch [S]elect Telescope" },
        { "<leader>sw", builtin.grep_string, desc = "[S]earch current [W]ord" },
        { "<leader>sg", builtin.live_grep, desc = "[S]earch by [G]rep" },
        { "<leader>sd", builtin.diagnostics, desc = "[S]earch [D]iagnostics" },
        { "<leader>sr", builtin.resume, desc = "[S]earch [R]esume" },
        { "<leader>s.", builtin.oldfiles, desc = "[S]earch recent files ('.' for repeat)" },
        { "<leader><leader>", builtin.buffers, desc = "[ ] Find existing buffers" },
        {
          "<leader>s/",
          function()
            builtin.live_grep({
              grep_open_files = true,
              prompt_title = "Live Grep in Open Files",
            })
          end,
          desc = "[S]earch [/] in open files",
        },
        {
          "<leader>sn",
          function()
            builtin.find_files({ cwd = vim.fn.stdpath("config") })
          end,
          desc = "[S]earch [N]eovim files",
        },
      }
    end,
    opts = function()
      return {
        extensions = {
          ["ui-select"] = {
            lazy_load = false,
            require("telescope.themes").get_dropdown(),
          },
          ["fzf"] = {
            lazy_load = false,
          },
        },
      }
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
      for ext, val in pairs(opts.extensions) do
        if val.lazy_load == false then
          pcall(require("telescope").load_extension, ext)
        end
      end
    end,
  },

  -- treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file
    event = "VeryLazy",
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    ---@type TSConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
      ensure_installed = {
        "query",
        "vim",
        "vimdoc",
      },
      auto_install = false,
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<leader>n",
          node_incremental = "<leader>n",
          node_decremental = "<bs>",
          scope_incremental = false,
        },
      },
      textobjects = {
        move = {
          enable = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]a"] = "@parameter.inner",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
            ["]A"] = "@parameter.inner",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[a"] = "@parameter.inner",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
            ["[A"] = "@parameter.inner",
          },
        },
      },
    },
    main = "nvim-treesitter.configs",
  },

  -- better text-objects
  {
    "echasnovski/mini.ai",
    version = "*",
    event = "VeryLazy",
    opts = {
      n_lines = 500,
    },
  },

  -- better surroundings
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    version = "*",
  },
}
