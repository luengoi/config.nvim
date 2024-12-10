local M = {}

---@type LazyKeysLspSpec[]|nil
M._keys = nil

---@alias LazyKeysLspSpec LazyKeysSpec|{has?:string|string[], cond?:fun():boolean}
---@alias LazyKeysLsp LazyKeys|{has?:string|string[], cond?:fun():boolean}

---@return LazyKeysLspSpec[]
function M.get()
  if M._keys then
    return M._keys
  end

  M._keys = {
    { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp info" },
    { "gd", vim.lsp.buf.definition, desc = "Goto definition", has = "definition" },
    { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
    { "gI", vim.lsp.buf.implementation, desc = "Goto [I]mplementation" },
    { "gy", vim.lsp.buf.type_definition, desc = "Goto t[y]pe definition" },
    { "gD", vim.lsp.buf.declaration, desc = "Goto [D]eclaration" },
    {
      "K",
      function()
        return vim.lsp.buf.hover()
      end,
      desc = "Hover",
    },
    {
      "gK",
      function()
        return vim.lsp.buf.signature_help()
      end,
      desc = "Signature help",
      has = "signatureHelp",
    },
    {
      "<c-k>",
      function()
        return vim.lsp.buf.signature_help()
      end,
      mode = "i",
      desc = "Signature help",
      has = "signatureHelp",
    },
    { "<leader>ca", vim.lsp.buf.code_action, desc = "Code action", mode = { "n", "v" }, has = "codeAction" },
    { "<leader>cc", vim.lsp.codelens.run, desc = "Run codelens", mode = { "n", "v" }, has = "codeLens" },
    { "<leader>cC", vim.lsp.codelens.refresh, desc = "Refresh & display codelens", mode = { "n" }, has = "codeLens" },
    { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", has = "rename" },
  }

  return M._keys
end

---@param method string|string[]
function M.has(buffer, method)
  if type(method) == "table" then
    for _, m in ipairs(method) do
      if M.has(buffer, m) then
        return true
      end
    end
    return false
  end
  method = method:find("/") and method or "textDocument/" .. method
  local clients = Util.lsp.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end
  return true
end

---@return LazyKeysLsp[]
function M.resolve(buffer)
  local Keys = require("lazy.core.handler.keys")
  if not Keys.resolve then
    return {}
  end
  local spec = vim.tbl_extend("force", {}, M.get())
  local opts = Util.opts("nvim-lspconfig")
  local clients = Util.lsp.get_clients({ bufnr = buffer })
  for _, client in ipairs(clients) do
    local maps = opts.servers[client.name] and opts.servers[client.name].keys or {}
    vim.list_extend(spec, maps)
  end
  return Keys.resolve(spec)
end

function M.on_attach(_, buffer)
  local Keys = require("lazy.core.handler.keys")
  local keymaps = M.resolve(buffer)

  for _, keys in pairs(keymaps) do
    local has = not keys.has or M.has(buffer, keys.has)
    local cond = not (keys.cond == false or ((type(keys.cond) == "function") and not keys.cond()))

    if has and cond then
      local opts = Keys.opts(keys)
      ---@diagnostic disable: inject-field
      opts.cond = nil
      opts.has = nil
      opts.silent = opts.silent ~= false
      opts.buffer = buffer
      ---@diagnostic disable: param-type-mismatch
      vim.keymap.set(keys.mode or "n", keys.lhs, keys.rhs, opts)
      ---@diagnostic enable: inject-field, param-type-mismatch
    end
  end
end

return M
