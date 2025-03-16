return {
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
