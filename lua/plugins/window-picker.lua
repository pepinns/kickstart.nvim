return {
    's1n7ax/nvim-window-picker',
    name = 'window-picker',
    event = 'VeryLazy',
    version = '2.*',
    opts =  {
      hint = 'floating-big-letter',
      show_prompt = true,
      filter_rules = {
          include_current_win = false,
          autoselect_one = true,
          -- filter using buffer options
          bo = {
              -- if the file type is one of following, the window will be ignored
              filetype = { 'neo-tree', "neo-tree-popup", "notify", "neotest-summary" },
              -- if the buffer type is one of following, the window will be ignored
              buftype = { 'terminal', "quickfix", "trouble" },
          },
      },
    },
    config = function(_, opts)
      require 'window-picker'.setup(opts)
    end,
    keys = {
      {
        "<leader>ww",
        function()
          local picker = require('window-picker')
          local picked_window_id = picker.pick_window({
                  hint = 'floating-big-letter',
                  filter_rules = {
                    bo = {
                      filetype = {},
                      buftype = {},
                    },
                  },
          })
          if picked_window_id then
            vim.api.nvim_set_current_win(picked_window_id)
          end
        end,
        desc = "Pick Window" 
      },
    },
}
