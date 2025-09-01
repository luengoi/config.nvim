-- plugins.lsp
-- LSP integration.

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
    dependencies = {
      "saghen/blink.cmp",
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
    },
    opts = {
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
      servers = {},
      setup = {
        -- Additional LSP server setup.
        -- Return true if this server should not be set up with lspconfig.
      },
    },
    config = function(_, opts)
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("mine-lsp-attach", { clear = true }),
        callback = function(event)
          local keymaps = require("plugins.lsp.keymaps")
          keymaps.setup(event.buf)

          local client = vim.lsp.get_client_by_id(event.data.client_id)

          -- Highlight references of the word under cursor.
          if
            client
            and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
          then
            local highlight_augroup = vim.api.nvim_create_augroup("mine-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("mine-lsp-detach", { clear = true }),
              callback = function(ev)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = "mine-lsp-highlight", buffer = ev.buf }
              end
            })
          end

          -- Inlay hints.
          if
            client
            and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
          then
            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })

            keymaps.map {
              "<leader>ch",
              function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
              end,
              buffer = event.buf,
              desc = "Toggle inlay [h]ints",
            }
          end

          -- Codelens.
          if client
            and client:supports_method(vim.lsp.protocol.Methods.textDocument_codeLens)
          then
            keymaps.map {
              "<leader>cl",
              vim.lsp.codelens.run,
              mode = { "n", "v" },
              buffer = event.buf,
              desc = "Run the code [l]ens in the current line",
            }
            keymaps.map {
              "<leader>cL",
              vim.lsp.codelens.refresh,
              mode = { "n", "v" },
              buffer = event.buf,
              desc = "Refresh the code [L]enses",
            }

            vim.api.nvim_create_autocmd({ "BufEnter" }, {
              group = vim.api.nvim_create_augroup("mine-lsp-refresh-codelens", { clear = true }),
              buffer = event.buf,
              callback = vim.lsp.codelens.refresh,
            })
          end
        end,
      })

      vim.diagnostic.config {
        severity_sort = true,
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = " ",
          },
        },
        virtual_text = {
          source = "if_many",
          spacing = 2,
        },
      }

      local servers = opts.servers
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        require("blink.cmp").get_lsp_capabilities(),
        opts.capabilities
      )

      local all_mlsp_servers = vim.tbl_keys(require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package)
      local function configure(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return true
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return true
          end
        end
        vim.lsp.config(server, server_opts)

        if server_opts.mason == false or not vim.tbl_contains(all_mlsp_servers, server) then
          vim.lsp.enable(server)
          return true
        end
        return false
      end

      local ensure_installed = {}
      local exclude_automatic_enable = {}
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then
            if configure(server) then
              exclude_automatic_enable[#exclude_automatic_enable + 1] = server
            else
              ensure_installed[#ensure_installed + 1] = server
            end
          else
            exclude_automatic_enable[#exclude_automatic_enable + 1] = server
          end
        end
      end

      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_deep_extend(
          "force",
          ensure_installed,
          Util.opts("mason-lspconfig").ensure_installed or {}
        ),
        exclude = exclude_automatic_enable,
      })
    end,
  },

  -- LSP server manager
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {},
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {},
    },
    config = function()
      -- Plugin is configured from nvim-lspconfig's config.
    end
  },
}
