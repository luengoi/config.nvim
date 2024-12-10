---@class Config
local M = {}

M.icons = {
  diagnostics = {
    Error = " ",
    Warn  = " ",
    Hint  = " ",
    Info  = " ",
  },
}

function M.setup()
  require("config.options")

  -- autocmds can be loaded lazily when not opening a file
  local lazy_autocmds = vim.fn.argc(-1) == 0
  if not lazy_autocmds then
    require("config.autocmds")
  end

  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("custom-config-load", { clear = true }),
    pattern = "VeryLazy",
    callback = function()
      if lazy_autocmds then
        require("config.autocmds")
      end
      require("config.keymaps")
    end,
  })
end

return M
