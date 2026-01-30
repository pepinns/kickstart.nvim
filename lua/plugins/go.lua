return {
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    ft = { 'go' },
    opts = {
      servers = {
        gopls = {
          mason_install = true,
          filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
          settings = {},
        },
      },
    },
  },
  {
    'fredrikaverpil/neotest-golang',
    ft = 'go',
    dependencies = {
      'nvim-neotest/neotest',
    },
    -- config is called after plugin/deps are loaded
    config = function()
      -- neotest allows calling setup N times and merges new configs with previous
      require('neotest').setup {
        adapters = {
          require 'neotest-golang' {
            go_test_args = { '-timeout=90s' },
            dap_go_enabled = true, -- requires leoluz/nvim-dap-go
          },
        },
      }
    end,
  },
  {
    'leoluz/nvim-dap-go',
    ft = 'go',
    dependencies = {
      'mfussenegger/nvim-dap',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    config = function()
      require('mason-tool-installer').setup { ensure_installed = { 'delve', 'goimports', 'gotests', 'impl', 'iferr' } }
    end,
  },
}
