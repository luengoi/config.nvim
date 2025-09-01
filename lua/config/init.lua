---@class Config
local M = {}

function M.setup()
  require("config.options")
  require("config.keymaps")
  require("config.commands")
end

return M
