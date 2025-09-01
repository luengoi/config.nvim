-- plugins.editor
-- set of plugins to improve the editor experience.

return {
  -- Directory management
  {
    "stevearc/oil.nvim",
    keys = {
      { "<leader>o", "<cmd>Oil<cr>", desc = "Open parent directory in Oil" },
    },
    lazy = not Util.is_running_in_dir(),
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
      },
    },
  },

  -- Fuzzy finder
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    keys = {
      { "<leader>sb", "<cmd>FzfLua buffers<cr>", desc = "Fuzzy find buffers" },
      { "<leader>sf", "<cmd>FzfLua files<cr>", desc = "Fuzzy find files" },
      { "<leader>sg", "<cmd>FzfLua live_grep<cr>", desc = "Live grep search" },
      { "<leader>ss", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Fuzzy find symbols (document)" },
      { "<leader>sS", "<cmd>FzfLua lsp_workspace_symbols<cr>", desc = "Fuzzy find symbols (workspace)" },
    },
    opts = {
      winopts = {
        preview = { hidden = true },
      },
    },
  },

  -- Git integration
  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Next hunk")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Prev hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Preview hunk inline")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame line")
        map("n", "<leader>ghB", function() gs.blame() end, "Blame buffer")
        map("n", "<leader>ghd", gs.diffthis, "Diff this")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff this ~")
      end,
    },
  },
}
