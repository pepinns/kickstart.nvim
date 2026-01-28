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
  },
}
