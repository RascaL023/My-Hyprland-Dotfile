return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "mfussenegger/nvim-jdtls",
    {
      "mattn/emmet-vim",
      ft = { "html", "css", "javascript", "javascriptreact", "typescriptreact", "vue", "svelte" },
      init = function()
        vim.g.user_emmet_leader_key = '<C-l>' -- Trigger: Ctrl+z lalu koma
        vim.g.user_emmet_mode = 'inv' 
        vim.g.user_emmet_install_global = 0
      end,
      config = function()
        vim.cmd([[
          autocmd FileType html,css,javascript,javascriptreact,typescriptreact EmmetInstall
        ]])
      end,
    },
  },

  config = function()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    -- =================================
    -- From System
    -- =================================

    vim.lsp.config.nixd = {
      default_config = {
        cmd = { "nixd" },
        filetypes = { "nix" },
        capabilities = capabilities,
        settings = {
          nixd = {
            nix = {
              flake = {
                autoEvalInputs = true, -- Sangat berguna kalau kamu pakai Nix Flakes
              },
            },
            -- Opsional: limit memory usage kalau nixd makan RAM kebanyakan
            -- maxMemoryMB = 2048, 
          },
        },
      },
    }vim.lsp.enable("nixd")

    vim.lsp.config.clangd = {
      default_config = {
        cmd = {
            "clangd",
        },
        filetypes = { "c", "cpp", "objc", "objcpp" },
        capabilities = capabilities,
      },
    }vim.lsp.enable("clangd")

    vim.lsp.config.lua_ls = {
      default_config = {
        cmd = { "lua-language-server" },
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      }
    }vim.lsp.enable("lua_ls")

    vim.lsp.config.intelephense = {
      default_config = {
        cmd = { "intelephense", "--stdio" },
        filetypes = { "php" },
        root_dir = function(fname)
          return vim.fs.dirname(vim.fs.find(
            { "composer.json", ".git" },
            { upward = true, path = fname }
          )[1])
        end,
        capabilities = capabilities,
        settings = {
          intelephense = {
            files = {
              maxSize = 5000000,
            },
          },
        },
      },
    }vim.lsp.enable("intelephense")

    vim.lsp.config.jsonls = {
      default_config = {
        cmd = { "vscode-json-languageserver", "--stdio" },
        filetypes = { "json", "jsonc" },
        capabilities = capabilities,
        settings = {
          json = {
            validate = { enable = true },
            schemas = {},
          },
        },
      },
    }vim.lsp.enable("jsonls")


    -- =================================
    -- From Mason
    -- =================================

    vim.lsp.config.gopls = {
      default_config = {
        capabilities = capabilities,
      }
    }vim.lsp.enable("gopls")

    vim.lsp.config.tsserver = {
        default_config = {
            cmd = { "typescript-language-server", "--stdio" },
            capabilities = capabilities,
            filetypes = {
                "javascript",
                "javascriptreact",
                "typescript",
                "typescriptreact",
            },
            root_dir = function(fname)
                return vim.fs.dirname(vim.fs.find(
                    { "package.json", "tsconfig.json", "jsconfig.json", ".git" },
                    { upward = true, path = fname }
                )[1])
            end,
        }
    }vim.lsp.enable("tsserver")

    vim.lsp.config.svelte = {
      default_config = {
        cmd = { "svelteserver", "--stdio" },
        filetypes = { "svelte" },
        capabilities = capabilities,
      }
    }vim.lsp.enable("svelte")

    vim.lsp.config.bashls = {
      default_config = {
        capabilities = capabilities,
      }
    }vim.lsp.enable("bashls")

    vim.lsp.config.postgres_lsp = {
      cmd = { "postgres-language-server", "lsp-proxy" },
      filetypes = { "sql" },
      root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        local root = vim.fs.root(fname, { "postgres-language-server.jsonc", ".git" })

        on_dir(root or vim.fs.dirname(fname))
      end,
      root_markers = { "postgres-language-server.jsonc", ".git" },
      workspace_required = false,
      default_config = {
        cmd = { "postgres-language-server", "lsp-proxy" },
        filetypes = { "sql" },
        capabilities = capabilities,
      }
    }vim.lsp.enable("postgres_lsp")

    vim.lsp.config.hyprls = {
      default_config = {
        capabilities = capabilities,
      }
    }vim.lsp.enable("hyprls")

    -- Nonaktifkan jdtls dari nvim-lspconfig — dikelola oleh nvim-jdtls via ftplugin/java.lua
    vim.lsp.config.jdtls = nil

  end,
}
