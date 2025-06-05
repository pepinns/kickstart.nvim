return {
  --{ 'github/copilot.vim' },
  {
    'github/copilot.vim',
    cmd = 'Copilot',
    event = 'BufWinEnter',
    init = function()
      vim.g.copilot_no_maps = true
    end,
    config = function()
      -- Block the normal Copilot suggestions
      vim.api.nvim_create_augroup('github_copilot', { clear = true })
      vim.api.nvim_create_autocmd({ 'FileType', 'BufUnload' }, {
        group = 'github_copilot',
        callback = function(args)
          vim.fn['copilot#On' .. args.event]()
        end,
      })
      vim.fn['copilot#OnFileType']()
    end,
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'github/copilot.vim' }, -- or zbirenbaum/copilot.lua
      { 'nvim-lua/plenary.nvim', branch = 'master' }, -- for curl, log and async functions
    },
    keys = {
      {
        '<localleader>ai',
        '<CMD>CopilotChatToggle<cr>',
        desc = 'Copilot Chat Toggle',
      },
      -- vim.api.nvim_set_keymap(‘i’, ‘<C-/>’, ‘copilot#Accept(“<CR>”)’, {expr=true, silent=true})
      {
        '<C-l>',
        '<cmd>copilot#Accept("<CR>")<cr>',
        desc = 'Copilot Accept Line',
      },
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    opts = {
      -- See Configuration section for options
    },
    -- See Commands section for default commands if you want to lazy load on them
  },
}
