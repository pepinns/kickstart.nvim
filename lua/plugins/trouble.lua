return {
  'folke/trouble.nvim',
  opts = {}, -- for default options, refer to the configuration section for custom setup.
  cmd = 'Trouble',
  keys = {
    {
      '<leader>en',
      function()
        local tro = require 'trouble'
        if not tro.is_open() then
          tro.open 'diagnostics'
        end

        tro.next {
          jump = true,
          follow = true,
          float = true,
        }
      end,
      desc = 'Next Diagnostics (Trouble)',
    },
    {
      '<leader>ep',
      function()
        local tro = require 'trouble'
        if not tro.is_open() then
          tro.open 'diagnostics'
        end
        tro.prev {
          jump = true,
          follow = true,
          float = true,
        }
      end,
      desc = 'Prev Diagnostics (Trouble)',
    },
    {
      '<leader>xx',
      '<cmd>Trouble diagnostics toggle<cr>',
      desc = 'Diagnostics (Trouble)',
    },
    {
      '<leader>xX',
      '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
      desc = 'Buffer Diagnostics (Trouble)',
    },
    {
      '<leader>cs',
      '<cmd>Trouble symbols toggle focus=false<cr>',
      desc = 'Symbols (Trouble)',
    },
    {
      '<leader>cl',
      '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
      desc = 'LSP Definitions / references / ... (Trouble)',
    },
    {
      '<leader>xL',
      '<cmd>Trouble loclist toggle<cr>',
      desc = 'Location List (Trouble)',
    },
    {
      '<leader>xQ',
      '<cmd>Trouble qflist toggle<cr>',
      desc = 'Quickfix List (Trouble)',
    },
  },
}
