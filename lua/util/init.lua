---@class Util
---@field lsp util.lsp
local M = {}

setmetatable(M, {
  __index = function(t, k)
    t[k] = require("util." .. k)
    return t[k]
  end,
})

--- Checks if neovim started running with args.
---@return boolean
function M.is_running_with_args()
  return vim.fn.argc(-1) > 0
end

--- Checks if neovim started running in a directory.
---@return boolean
function M.is_running_in_dir()
  local stats = vim.uv.fs_stat(vim.fn.argv(0))
  if stats and stats.type == "directory" then
    return true
  else
    return false
  end
end

---@param name string
function M.opts(name)
  local plugin = require("lazy.core.config").spec.plugins[name]
  if not plugin then
    return {}
  end
  return require("lazy.core.plugin").values(plugin, "opts", false)
end

return M
