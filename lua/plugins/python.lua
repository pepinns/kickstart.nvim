return {
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    ft = { 'python' },
    opts = {
      servers = {
        pyright = {
          mason_install = true,
          settings = {},
        },
      },
    },
    config = function()
      -- Enable pyright only when Python files are opened
      vim.lsp.enable('pyright')
    end,
  },
}
