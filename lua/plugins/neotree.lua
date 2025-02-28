function neotree_toggle()
  local bufname = vim.fn.bufname()
  vim.print(bufname)
  local is_neotree_buffer = string.match(bufname, 'neo%-tree [^ ]+ %[%d+]')
  require('neo-tree.command').execute { toggle = is_neotree_buffer, dir = vim.uv.cwd() }
end
return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    's1n7ax/nvim-window-picker',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  keys = {
    {
      '<C-f>',
      neotree_toggle,
      desc = 'NeoTree (cwd)',
      mode = { 'n', 'x' },
    },
    {
      '<leader>ft',
      neotree_toggle,
      desc = 'NeoTree (cwd)',
    },
    {
      '<leader>fT',
      function()
        require('neo-tree').close_all()
      end,
      desc = 'NeoTree close',
    },
  },

  opts = {
    filesystem = {
      bind_to_cwd = true,
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
    },
    open_files_do_not_replace_types = { 'terminal', 'Trouble', 'qf', 'edgy' },
    window = {
      mappings = {
        ['<C-f>'] = 'none', -- used for toggle neotree
        ['<C-k>'] = { 'scroll_preview', config = { direction = 10 } },
        ['<C-j>'] = { 'scroll_preview', config = { direction = -10 } },
        ['<space>'] = 'none',
        ['l'] = 'open',
        ['h'] = 'close_node',
        ['-'] = 'split_with_window_picker',
        ['|'] = 'vsplit_with_window_picker',
        ['Y'] = {
          function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg('+', path, 'c')
          end,
          desc = 'Copy Path to Clipboard',
        },
        ['P'] = { 'toggle_preview', config = { use_float = true } },
      },
    },
  },
}
