-- plugins.lsp.keymaps
-- LSP keymappings. These keymaps are registered on the 'LspAttach' autocmd.

---@class plugins.lsp.keymaps
local M = {}

---@class BaseKeyMapSpec
---@field [1] string lhs
---@field [2] string|fun() rhs
---@field mode? string|string[]
---@field desc string

---@class KeyMapSpec: BaseKeyMapSpec
---@field buffer integer

---@param spec KeyMapSpec
function M.map(spec)
  local mode = spec.mode or "n"
  vim.keymap.set(mode, spec[1], spec[2], { buffer = spec.buffer, desc = "LSP: " .. spec.desc })
end

function M.setup(buffer)
  ---@param spec BaseKeyMapSpec
  local function map(spec)
    ---@type KeyMapSpec
    local complete_spec = vim.tbl_extend("force", spec, { buffer = buffer })
    M.map(complete_spec)
  end

  map({ "<leader>cr", vim.lsp.buf.rename, desc = "[R]ename all references to symbol under the cursor" })
  map({ "<leader>ca", vim.lsp.buf.code_action, desc = "Select a code [a]ction available at cursor position" })
  map({ "gd", vim.lsp.buf.definition, desc = "[G]o to the [d]efinition of the symbol under the cursor" })
  map({ "gD", vim.lsp.buf.declaration, desc = "[G]o to the [D]eclaration of the symbol under the cursor" })
  map({
    "K",
    function()
      vim.lsp.buf.hover({ border = "rounded" })
    end,
    desc = "Display hover information about the symbol under the cursor",
  })
  map({
    "gK",
    function()
      vim.lsp.buf.signature_help({ border = "rounded" })
    end,
    desc = "Display signature information about the symbol under the cursor",
  })
  map({
    "<c-k>",
    function()
      vim.lsp.buf.signature_help({ border = "rounded" })
    end,
    mode = "i",
    desc = "Display signature information about the symbol under the cursor",
  })
end

return M
