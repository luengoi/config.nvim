local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

_G.Config = require("config")
_G.Util = require("util")

Config.setup()

require("lazy").setup({
  spec = {
    { import = "plugins" },
    { import = "lang" },
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      config = function(_, opts)
        local notify = vim.nofity
        require("snacks").setup(opts)
        -- HACK: restore vim.notify after snacks setup and let noice.nvim
        -- take over. This is needed to have early notifications show up
        -- in history.
        vim.notify = notify
      end,
    },
  },
  install = { colorscheme = { "catppuccin" } },
  checker = { enabled = true },
})
