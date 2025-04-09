return {
  -- {
  --     'williamboman/mason-lspconfig.nvim',
  --     ft = 'rust',
  --     config = function()
  --         vim.print("In rust config")
  --         require("lspconfig").rust_analyzer.setup {}
  --     end
  -- },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    ft = { 'rust' },
    opts = {
      servers = {
        -- https://github.com/rust-lang/rust-analyzer/blob/master/crates/rust-analyzer/src/config.rs#L548
        rust_analyzer = {
          -- mason_install = true,
          settings = {
            ['rust-analyzer'] = {
              diagnostics = {
                enable = true,
                disabled = { 'unresolved-proc-macro', 'unresolved-macro-call', 'proc-macro-disabled' },
              },
              typing = {
                triggerChars = '=.{><',
              },
              hover = {
                maxSubstitutionLength = 200,
                show = {
                  fields = 20,
                  enumVariants = 20,
                  traitAssocItems = 20,
                },
              },

              semanticHighlighting = {
                punctuation = {
                  enable = true,
                  specialization = {
                    enable = true,
                  },
                  separate = {
                    macro = {
                      bang = true,
                    },
                  },
                },
                operator = {
                  enable = true,
                  specialization = {
                    enable = true,
                  },
                },
              },
              procMacro = {
                -- enable = true,
                -- attributes = {
                --   enable = true,
                -- },
                ignored = {
                  ['async-trait'] = { 'async_trait' },
                  ['googletest'] = { 'gtest', 'test' },
                  ['rstest'] = { 'rstest', 'awt' },
                },
              },
            },
          },
        },
      },
    },
  },
   {
    "Saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        crates = {
          enabled = true,
        },
      },
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
  {
    'rouge8/neotest-rust',
    ft = 'rust',
    dependencies = {
      'nvim-neotest/neotest',
    },
    -- config is called after plugin/deps are loaded
    config = function()
      -- neotest allows calling setup N times and merges new configs with previous
      require('neotest').setup {
        adapters = {
          require 'neotest-rust' {
            -- options go here
          },
        },
      }
    end,
  },
}
