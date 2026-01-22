-- LC_TERMINAL=iTerm2
if os.getenv 'LC_TERMINAL' == 'iTerm2' then
  vim.opt.termguicolors = true
end

vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy '+',
    ['*'] = require('vim.ui.clipboard.osc52').copy '*',
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste '+',
    ['*'] = require('vim.ui.clipboard.osc52').paste '*',
  },
}

--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ','

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- [[ Setting options ]]

-- Make line numbers default
vim.opt.number = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.lsp.foldexpr()'
vim.o.foldtext = 'v:lua.vim.lsp.foldtext()'
vim.o.foldlevel = 99
vim.o.foldnestmax = 2

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  {
    'rktjmp/lush.nvim',
    -- if you wish to use your own colorscheme:
    { dir = '~/pjs/vimcolors', lazy = true },
  },
  install = { colorscheme = { 'vimcolors' } },
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  -- 'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- NOTE: Plugins can also be added by using a table,
  -- with the first argument being the link and the following
  -- keys can be used to configure plugin behavior/loading/etc.
  --
  -- Use `opts = {}` to force a plugin to be loaded.
  --

  -- Here is a more advanced example where we pass configuration
  -- options to `gitsigns.nvim`. This is equivalent to the following Lua:
  --    require('gitsigns').setup({ ... })
  --
  -- See `:help gitsigns` to understand what the configuration keys do
  -- { -- Adds git related signs to the gutter, as well as utilities for managing changes
  --   'lewis6991/gitsigns.nvim',
  --   opts = {
  --     signs = {
  --       add = { text = '+' },
  --       change = { text = '~' },
  --       delete = { text = '_' },
  --       topdelete = { text = '‾' },
  --       changedelete = { text = '~' },
  --     },
  --   },
  -- },

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.
  --
  -- This is often very useful to both group configuration, as well as handle
  -- lazy loading plugins that don't need to be loaded immediately at startup.
  --
  -- For example, in the following configuration, we use:
  --  event = 'VimEnter'
  --
  -- which loads which-key before all the UI elements are loaded. Events can be
  -- normal autocommands events (`:help autocmd-events`).
  --
  -- Then, because we use the `opts` key (recommended), the configuration runs
  -- after the plugin has been loaded as `require(MODULE).setup(opts)`.

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.opt.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        {
          mode = { 'n', 'v' },
          { '<leader><tab>', group = 'tabs' },
          { '<leader>c', group = 'code' },
          { '<leader>t', group = 'test' },
          { '<leader>w', group = 'window' },
          { '<leader>e', group = 'error' },
          { '<localleader>t', group = 'test' },
          { '<leader>d', group = 'debug' },
          { '<leader>dp', group = 'profiler' },
          { '<leader>f', group = 'file/find' },
          { '<leader>g', group = 'git' },
          { '<leader>gh', group = 'hunks' },
          { '<leader>q', group = 'quit/session' },
          { '<leader>s', group = 'search' },
          { '<leader>u', group = 'ui', icon = { icon = '󰙵 ', color = 'cyan' } },
          { '<leader>x', group = 'diagnostics/quickfix', icon = { icon = '󱖫 ', color = 'green' } },
          { '[', group = 'prev' },
          { ']', group = 'next' },
          { 'g', group = 'goto' },
          { 'gs', group = 'surround' },
          { 'z', group = 'fold' },
          {
            '<leader>b',
            group = 'buffer',
            expand = function()
              return require('which-key.extras').expand.buf()
            end,
          },
          {
            '<leader>w',
            group = 'windows',
            proxy = '<c-w>',
            expand = function()
              return require('which-key.extras').expand.win()
            end,
          },
        },
      },
    },
    keys = {
      {
        '<leader>?',
        function()
          require('which-key').show { global = false }
        end,
        desc = 'Buffer Local Keymaps (which-key)',
      },
      {
        '<leader>cf',
        function()
          require('conform').format()
        end,
        desc = 'Format',
      },
      {
        '<localleader>fm',
        function()
          find_file_from_here 'mod.rs'
        end,
        desc = 'Open mod.rs',
      },
      {
        '<localleader>fl',
        function()
          find_file_from_here 'lib.rs'
        end,
        desc = 'Open lib.rs',
      },
      {
        '<localleader>cc',
        function()
          find_file_from_here 'Cargo.toml'
        end,
        desc = 'Open (workspace) Cargo.toml',
      },
      {
        '<localleader>cw',
        function()
          find_file_in_root 'Cargo.toml'
        end,
        desc = 'Open (workspace) Cargo.toml',
      },
      {
        '<localleader>cm',
        function()
          find_file_in_root 'Makefile'
        end,
        desc = 'Open (workspace) Makefile',
      },
    },
  },

  {
    'folke/snacks.nvim',
    opts = {
      picker = {
        -- your picker configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
        -- projects = {
        --   dev = { '~/pjs' },
        -- },
      },
      statuscolumn = {
        -- your statuscolumn configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      },
      terminal = {
        -- use defaults
      },
    },
    keys = { -- https://lazy.folke.io/spec/lazy_loading#%EF%B8%8F-lazy-key-mappings
      {
        '<leader>ot',
        function()
          Snacks.terminal()
        end,
        desc = 'Open terminal',
      },
      {
        '<leader>gb',
        function()
          Snacks.git.blame_line()
        end,
        desc = 'Git Blame',
      },
      {
        '<leader>:',
        function()
          Snacks.picker.command_history()
        end,
        desc = 'Command History',
      },
      {
        '<leader>fc',
        function()
          Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
        end,
        desc = 'Find Config File',
      },
      -- {
      --   '<leader>fp',
      --   function()
      --     Snacks.picker.projects()
      --   end,
      --   desc = 'Projects',
      -- },
      {
        '<leader>gY',
        function()
          Snacks.gitbrowse {
            open = function(url)
              vim.fn.setreg('+', url)
            end,
            notify = false,
          }
        end,
        desc = 'Git Browse (copy)',
        mode = { 'n', 'v' },
      },
    },
  },
  -- NOTE: Plugins can specify dependencies.
  --
  -- The dependencies are proper plugin specifications as well - anything
  -- you do for a plugin at the top level, you can do for a dependency.
  --
  -- Use the `dependencies` key to specify the dependencies of a particular plugin

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader><leader>', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader>bb', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>sb', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },
  {
    'ahmedkhalf/project.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
    },
    keys = {
      {
        '<leader>fp',
        function()
          require('telescope').extensions.projects.projects { only_sort_text = true }
        end,
        desc = 'Open Project',
      },
    },
    init = function()
      require('project_nvim').setup {
        detection_methods = { 'pattern', 'lsp' },
        patterns = {
          '>pjs',
          '.git',
          '_darcs',
          '.hg',
          '.bzr',
          '.svn',
          'package.json',
          'Cargo.lock',
          'lazy-lock.json',
        },
      }

      require('telescope').load_extension 'projects'
      -- require'telescope'.load_extension('project')
    end,
  },

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by nvim-cmp
      -- 'hrsh7th/cmp-nvim-lsp',
    },
    -- if this spec defines opts like this, then you can't override it in others.
    -- opts = {
    --   inlay_hints = { enabled = true },
    -- },
    -- Only one spec can define config.
    -- Don't redefine this func in lang-specific specs you wish to merge
    config = function(_, opts)
      -- Brief aside: **What is LSP?**
      --
      -- LSP is an initialism you've probably heard, but might not understand what it is.
      --
      -- LSP stands for Language Server Protocol. It's a protocol that helps editors
      -- and language tooling communicate in a standardized fashion.
      --
      -- In general, you have a "server" which is some tool built to understand a particular
      -- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
      -- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
      -- processes that communicate with some "client" - in this case, Neovim!
      -- vim.print("Opts: ", opts)
      -- LSP provides Neovim with features like:
      --  - Go to definition
      --  - Find references
      --  - Autocompletion
      --  - Symbol Search
      --  - and more!
      --
      -- Thus, Language Servers are external tools that must be installed separately from
      -- Neovim. This is where `mason` and related plugins come into play.
      --
      -- If you're wondering about lsp vs treesitter, you can check out the wonderfully
      -- and elegantly composed help section, `:help lsp-vs-treesitter`

      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' })

          require 'telescope.builtin'
          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          map('gD', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          map('gc', require('telescope.builtin').lsp_incoming_calls, '[G]oto Incoming [C]alls')
          map('<leader>cc', require('telescope.builtin').lsp_incoming_calls, '[G]oto Incoming [C]alls')
          map('gC', require('telescope.builtin').lsp_outgoing_calls, '[G]oto Outgoing [C]alls')
          map('<leader>cC', require('telescope.builtin').lsp_outgoing_calls, '[G]oto Outgoing [C]alls')

          -- Add a border to the hover for K
          map('K', function()
            vim.lsp.buf.hover { border = 'rounded' }
          end, 'Hover Doc')

          map('<C-K>', function()
            vim.lsp.buf.signature_help { border = 'rounded', anchor_bias = 'above' }
          end, 'Signature Help')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('<leader>ci', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>cd', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
          map('gy', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          map('<leader>ce', function()
            vim.lsp.buf_request(0, 'rust-analyzer/expandMacro', vim.lsp.util.make_position_params(), function(err, result, ctx, config)
              if err then
                vim.print('Error: ' .. err.message)
                return
              end
              local buf = vim.api.nvim_create_buf(false, true)
              local exp = result['expansion']
              local lines = {}
              for line in exp:gmatch '[^\r\n]+' do
                table.insert(lines, line)
              end
              vim.api.nvim_buf_set_text(buf, 0, 0, 0, -1, exp)
              local win = vim.api.nvim_open_win(buf, true, opts)
              vim.api.nvim_win_set_option(win, 'winblend', 15)

              local function close_popup()
                vim.api.nvim_win_close(win, true)
              end

              vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>lua close_popup()<CR>', { noremap = true, silent = true })
            end)
          end, 'expand macro')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>cs', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>cw', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>cr', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

          map('<C-a>', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'i', 'n', 'x' })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gH', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          map('<leader>ch', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- vim.cmd [[set completeopt+=menuone,noselect,popup]]
          -- -- setup native completion
          -- vim.lsp.completion.enable(true, client.id, event.buf, {
          --   autotrigger = true,
          --   convert = function(item)
          --     return { abbr = item.label:gsub('%b()', '') }
          --   end,
          -- })
          -- -- Use CTRL-space to trigger LSP completion.
          -- -- Use CTRL-Y to select an item. |complete_CTRL-Y|
          -- vim.keymap.set('i', '<c-space>', function()
          --   vim.lsp.completion.get()
          -- end)
          --
          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            vim.lsp.inlay_hint.enable()
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Change diagnostic symbols in the sign column (gutter)
      if vim.g.have_nerd_font then
        local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
        local diagnostic_signs = {}
        for type, icon in pairs(signs) do
          diagnostic_signs[vim.diagnostic.severity[type]] = icon
        end
        vim.diagnostic.config {
          virtual_text = {
            enabled = true,
            severity = {
              max = vim.diagnostic.severity.WARN,
            },
          },
          virtual_lines = {
            enabled = true,
            severity = {
              min = vim.diagnostic.severity.ERROR,
            },
          },
          signs = { text = diagnostic_signs },
        }
      end

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())
      capabilities = vim.tbl_deep_extend('force', capabilities, require('blink-cmp').get_lsp_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        gopls = {
          mason_install = true,
        },
        -- pyright = {},
        -- https://github.com/rust-lang/rust-analyzer/blob/master/crates/rust-analyzer/src/config.rs#L548
        rust_analyzer = {
          mason_install = false,
          cmd = { os.getenv 'HOME' .. '/.cargo/bin/rust-analyzer' },
          capabilities = {
            offsetEncoding = { 'utf-16' },
          },
          settings = {
            ['rust-analyzer'] = {
              cargo = {
                allFeatures = true,
                features = 'all',
              },
              checkOnSave = true,
              -- checkOnSave = {
              --   command = 'check', -- or "check"
              --   extraArgs = { '--all-features', '--tests' },
              -- },
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
                enable = true,
                attributes = {
                  enable = true,
                },
                ignored = {
                  ['async-trait'] = { 'async_trait' },
                  ['googletest'] = { 'gtest', 'test' },
                  ['rstest'] = { 'rstest', 'awt' },
                },
              },
            },
          },
        },
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        -- ts_ls = {},
        --

        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      -- Merge the servers defined in init.lua with those from plugin-specific opts
      opts.servers = vim.tbl_deep_extend('force', {}, servers, opts.servers or {})

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      --
      -- `mason` had to be setup earlier: to configure its options see the
      -- `dependencies` table for `nvim-lspconfig` above.
      --
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      
      -- Configure global LSP settings that apply to all servers
      vim.lsp.config('*', {
        capabilities = capabilities,
      })
      
      -- Configure each server and enable it using the new vim.lsp.config API
      for server_name, server in pairs(opts.servers) do
        -- Extract mason_install flag and remove it from the server config
        local mason_install = server.mason_install
        
        -- Create a clean server config without mason-specific fields
        local server_config = vim.tbl_deep_extend('force', {}, server)
        server_config.mason_install = nil
        
        -- Merge server-specific capabilities with global capabilities
        server_config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server_config.capabilities or {})
        
        vim.lsp.config(server_name, server_config)
        vim.lsp.enable(server_name)
      end
      
      -- Setup mason to install the servers
      local ensure_installed = {}
      for server in pairs(opts.servers) do
        if opts.servers[server].mason_install == true then
          table.insert(ensure_installed, server)
        end
      end
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        -- Conform can also run multiple formatters sequentially
        -- python = { "isort", "black" },
        --
        -- You can use 'stop_after_first' to run the first available formatter from the list
        -- javascript = { "prettierd", "prettier", stop_after_first = true },
      },
    },
  },
  { -- optional blink completion source for require statements and module annotations
    'saghen/blink.cmp',
    version = '*',
    -- build = "cargo build --release",
    opts_extend = {
      'sources.completion.enabled_providers',
      'sources.compat',
      'sources.default',
    },
    dependencies = {
      'fang2hou/blink-copilot',
      'rafamadriz/friendly-snippets',
      -- add blink.compat to dependencies
      {
        'saghen/blink.compat',
        optional = true, -- make optional so it's only enabled if any extras need it
        opts = {},
        version = '*',
      },
    },
    event = 'InsertEnter',
    opts = {
      appearance = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = false,
        -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'mono',
      },
      completion = {
        trigger = {
          show_on_trigger_character = true,
        },
        list = {
          selection = {
            preselect = function(ctx)
              return ctx.mode ~= 'cmdline' --and not require("blink.cmp").snippet_active({ direction = 1 })
            end,
            auto_insert = function(ctx)
              return ctx.mode ~= 'cmdline'
            end,
          },
        },
        accept = {
          -- experimental auto-brackets support
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          auto_show = true,
          draw = {
            treesitter = { 'lsp' },
            columns = {
              -- { "kind_icon", "label", "label_description", gap = 1 },
              { 'kind_icon', 'label', gap = 1 },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
          treesitter_highlighting = true,
          window = { border = 'rounded' },
        },
        ghost_text = {
          enabled = true,
        },
      },
      signature = {
        enabled = true,
        window = { border = 'rounded' },
      },
      sources = {
        -- add lazydev to your completion providers
        default = { 'lazydev', 'lsp', 'copilot', 'path', 'snippets', 'buffer' },
        -- default = { 'copilot' },
        providers = {
          copilot = {
            name = 'copilot',
            module = 'blink-copilot',
            score_offset = 50,
            async = true,
          },
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            -- make lazydev completions top priority (see `:h blink.cmp`)
            score_offset = 100,
          },
          lsp = {
            min_keyword_length = 0,
            score_offset = 100,
          },
          snippets = {
            min_keyword_length = 2,
            score_offset = 0,
          },
        },
      },
      keymap = {
        preset = 'enter',
        ['<C-y>'] = { 'select_and_accept' },
      },
    },
    config = function(_, opts)
      require('blink.cmp').setup(opts)
    end,
  },

  -- { -- Autocompletion
  --   'hrsh7th/nvim-cmp',
  --   event = 'InsertEnter',
  --   dependencies = {
  --     -- Snippet Engine & its associated nvim-cmp source
  --     {
  --       'L3MON4D3/LuaSnip',
  --       build = (function()
  --         -- Build Step is needed for regex support in snippets.
  --         -- This step is not supported in many windows environments.
  --         -- Remove the below condition to re-enable on windows.
  --         if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
  --           return
  --         end
  --         return 'make install_jsregexp'
  --       end)(),
  --       dependencies = {
  --         -- `friendly-snippets` contains a variety of premade snippets.
  --         --    See the README about individual language/framework/plugin snippets:
  --         --    https://github.com/rafamadriz/friendly-snippets
  --         -- {
  --         --   'rafamadriz/friendly-snippets',
  --         --   config = function()
  --         --     require('luasnip.loaders.from_vscode').lazy_load()
  --         --   end,
  --         -- },
  --       },
  --     },
  --     'saadparwaiz1/cmp_luasnip',
  --
  --     -- Adds other completion capabilities.
  --     --  nvim-cmp does not ship with all sources by default. They are split
  --     --  into multiple repos for maintenance purposes.
  --     'hrsh7th/cmp-nvim-lsp',
  --     'hrsh7th/cmp-buffer',
  --     'hrsh7th/cmp-path',
  --     -- 'hrsh7th/cmp-vsnip',
  --     'hrsh7th/cmp-nvim-lua',
  --     'hrsh7th/cmp-nvim-lsp',
  --     'hrsh7th/cmp-nvim-lsp-signature-help',
  --   },
  --   config = function()
  --     -- See `:help cmp`
  --     local cmp = require 'cmp'
  --     local luasnip = require 'luasnip'
  --     luasnip.config.setup {}
  --
  --     cmp.setup {
  --       snippet = {
  --         expand = function(args)
  --           luasnip.lsp_expand(args.body)
  --         end,
  --       },
  --       completion = { completeopt = 'menu,menuone,noinsert' },
  --
  --       -- For an understanding of why these mappings were
  --       -- chosen, you will need to read `:help ins-completion`
  --       --
  --       -- No, but seriously. Please read `:help ins-completion`, it is really good!
  --       mapping = cmp.mapping.preset.insert {
  --         -- Select the [n]ext item
  --         ['<C-n>'] = cmp.mapping.select_next_item(),
  --         -- Select the [p]revious item
  --         ['<C-p>'] = cmp.mapping.select_prev_item(),
  --
  --         -- Scroll the documentation window [b]ack / [f]orward
  --         ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  --         ['<C-f>'] = cmp.mapping.scroll_docs(4),
  --
  --         -- Accept ([y]es) the completion.
  --         --  This will auto-import if your LSP supports it.
  --         --  This will expand snippets if the LSP sent a snippet.
  --         ['<C-y>'] = cmp.mapping.confirm { select = true },
  --
  --         -- If you prefer more traditional completion keymaps,
  --         -- you can uncomment the following lines
  --         ['<CR>'] = cmp.mapping.confirm { select = true },
  --         --['<Tab>'] = cmp.mapping.select_next_item(),
  --         --['<S-Tab>'] = cmp.mapping.select_prev_item(),
  --
  --         -- Manually trigger a completion from nvim-cmp.
  --         --  Generally you don't need this, because nvim-cmp will display
  --         --  completions whenever it has completion options available.
  --         ['<C-Space>'] = cmp.mapping.complete {},
  --
  --         -- Think of <c-l> as moving to the right of your snippet expansion.
  --         --  So if you have a snippet that's like:
  --         --  function $name($args)
  --         --    $body
  --         --  end
  --         --
  --         -- <c-l> will move you to the right of each of the expansion locations.
  --         -- <c-h> is similar, except moving you backwards.
  --         ['<C-l>'] = cmp.mapping(function()
  --           if luasnip.expand_or_locally_jumpable() then
  --             luasnip.expand_or_jump()
  --           end
  --         end, { 'i', 's' }),
  --         ['<C-h>'] = cmp.mapping(function()
  --           if luasnip.locally_jumpable(-1) then
  --             luasnip.jump(-1)
  --           end
  --         end, { 'i', 's' }),
  --
  --         -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
  --         --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
  --       },
  --       sources = {
  --         {
  --           name = 'lazydev',
  --           -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
  --           group_index = 0,
  --         },
  --         { name = 'nvim_lsp' },
  --         { name = 'nvim_lsp_signature_help' },
  --         { name = 'luasnip' },
  --         { name = 'path' },
  --       },
  --       sorting = {
  --         priority_weight = 1.0,
  --         comparators = {
  --           cmp.config.compare.offset,
  --           cmp.config.compare.exact,
  --           cmp.config.compare.score,
  --           cmp.config.compare.recently_used,
  --           -- cmp.config.compare.kind,
  --           compare_fields_top,
  --           cmp.config.compare.score, -- based on :  score = score + ((#sources - (source_index - 1)) * sorting.priority_weight)
  --           -- cmp.config.compare.locality,
  --           -- cmp.config.compare.recently_used,
  --           -- cmp.config.compare.offset,
  --           -- cmp.config.compare.order,
  --           -- compare.scopes, -- what?
  --           -- compare.sort_text,
  --           -- cmp.compare.exact,
  --           -- compare.length, -- useless
  --         },
  --       },
  --     }
  --   end,
  -- },

  -- { -- You can easily change to a different colorscheme.
  --   -- Change the name of the colorscheme plugin below, and then
  --   -- change the command in the config to whatever the name of that colorscheme is.
  --   --
  --   -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
  --   'folke/tokyonight.nvim',
  --   priority = 1000, -- Make sure to load this before all the other start plugins.
  --   init = function()
  --     -- Load the colorscheme here.
  --     -- Like many other themes, this one has different styles, and you could load
  --     -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
  --     vim.cmd.colorscheme 'tokyonight-night'
  --
  --     -- You can configure highlights by doing something like:
  --     vim.cmd.hi 'Comment gui=none'
  --   end,
  -- },
  --
  -- -- Highlight todo, notes, etc in comments
  -- { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  --
  -- { -- Collection of various small independent plugins/modules
  --   'echasnovski/mini.nvim',
  --   config = function()
  --     -- Better Around/Inside textobjects
  --     --
  --     -- Examples:
  --     --  - va)  - [V]isually select [A]round [)]paren
  --     --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
  --     --  - ci'  - [C]hange [I]nside [']quote
  --     require('mini.ai').setup { n_lines = 500 }
  --
  --     -- Add/delete/replace surroundings (brackets, quotes, etc.)
  --     --
  --     -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
  --     -- - sd'   - [S]urround [D]elete [']quotes
  --     -- - sr)'  - [S]urround [R]eplace [)] [']
  --     require('mini.surround').setup()
  --
  --     -- Simple and easy statusline.
  --     --  You could remove this setup call if you don't like it,
  --     --  and try some other statusline plugin
  --     local statusline = require 'mini.statusline'
  --     -- set use_icons to true if you have a Nerd Font
  --     statusline.setup { use_icons = vim.g.have_nerd_font }
  --
  --     -- You can configure sections in the statusline by overriding their
  --     -- default behavior. For example, here we set the section for
  --     -- cursor location to LINE:COLUMN
  --     ---@diagnostic disable-next-line: duplicate-set-field
  --     statusline.section_location = function()
  --       return '%2l:%-2v'
  --     end
  --
  --     -- ... and there is more!
  --     --  Check out: https://github.com/echasnovski/mini.nvim
  --   end,
  -- },
  {
    'echasnovski/mini.indentscope',
    version = '*',
    opts = {
      symbol = '│',
    },
  },
  {
    'echasnovski/mini.icons',
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = { 'rust', 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },

  -- The following comments only work if you have downloaded the kickstart repo, not just copy pasted the
  -- init.lua. If you want these files, they are in the repository, so you can just download them and
  -- place them in the correct locations.

  -- NOTE: Next step on your Neovim journey: Add/Configure additional plugins for Kickstart
  --
  --  Here are some example plugins that I've included in the Kickstart repository.
  --  Uncomment any of the lines below to enable them (you will need to restart nvim).
  --
  -- require 'kickstart.plugins.debug',
  -- require 'kickstart.plugins.indent_line',
  -- require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  -- require 'kickstart.plugins.neo-tree',
  -- require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  --
  --  Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  -- { import = 'custom.plugins' },
  --
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
  -- import your plugins
  { import = 'plugins' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

vim.cmd.colorscheme 'vimcolors'
local map = vim.keymap.set

-- map('n', '<leader>xx', vim.diagnostic.setqflist, { desc = 'Open diagnostic [Q]uickfix list' })
map('n', '<leader>xl', vim.diagnostic.open_float, { desc = 'Open line diagnostic' })
-- map('n', '<leader>xn', function()
--   local success = pcall(vim.cmd, 'cnext')
--   if not success then
--     vim.cmd 'cfirst'
--   end
-- end, { desc = 'next diagnostic' })
-- map('n', '<leader>xp', function()
--   local success = pcall(vim.cmd, 'cprev')
--   if not success then
--     vim.cmd 'clast'
--   end
-- end, { desc = 'prev diagnostic' })
-- map({ 'n', 'v' }, ']]', '<cmd>Telescope quickfix<cr>', { desc = 'next quickfix' })
-- map({ 'n', 'v' }, '[[', '<cmd>lprev<cr>', { desc = 'prev quickfix' })

map('n', '<leader>qa', '<cmd>qall<cr><esc>', { desc = 'Quit' })
map('n', '<C-q>', '<cmd>q<cr><esc>', { desc = 'Quit' })
map('n', '<leader>fs', '<cmd>w<cr><esc>', { desc = 'Save File' })
map({ 'n', 'i', 'v' }, '<C-s>', '<cmd>w<cr><esc>', { desc = 'Save File' })
map('v', 'Y', '"*y', { desc = 'Copy to System Clipboard [ "*y ]', remap = false })
-- Windows
--  See `:help wincmd` for a list of all window commands
-- map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
--
map('n', '<leader>wd', '<C-w>q', { desc = 'close window' })
-- map('n', '<leader>wl', '<C-w>l', { desc = 'window right' })
-- map('n', '<leader>wh', '<C-w>h', { desc = 'window left' })
-- map('n', '<leader>wj', '<C-w>j', { desc = 'window down' })
-- map('n', '<leader>wk', '<C-w>k', { desc = 'window up' })
map('n', '<leader>w|', '<C-w>v', { desc = 'vertical split' })
map('n', '<leader>w_', '<C-w>h', { desc = 'horizontal split' })
map('n', '<leader>wm', '<C-w>o', { desc = 'close other windows' })
map('n', '<leader>wT', '<C-w>T', { desc = 'move window to new tab page' })
map('n', '<leader>wL', '<C-w>L', { desc = 'move window far right' })
map('n', '<leader>wH', '<C-w>H', { desc = 'move window far left' })
map('n', '<leader>wJ', '<C-w>J', { desc = 'move window to very bottom' })
map('n', '<leader>wK', '<C-w>K', { desc = 'move window to very top' })
map('n', '<leader>wx', '<C-w>x', { desc = 'exchange window with next' })

map('n', 'g>', '<cmd>tabnext<cr>', { desc = 'next tab' })
map('n', 'g<', '<cmd>tabprevious<cr>', { desc = 'next tab' })

-- map({ 'n', 'v' }, ']e', '<cmd>cnext<cr>', { desc = 'next quickfix' })
-- map({ 'n', 'v' }, '[e', '<cmd>cprev<cr>', { desc = 'prev quickfix' })
-- map({ 'n', 'v' }, ']E', '<cmd>clast<cr>', { desc = 'last quickfix' })

function find_file_in_root(filename)
  local cargo_path = vim.fs.joinpath(vim.fn.getcwd(0), filename)
  if vim.fn.filereadable(cargo_path) then
    vim.cmd('e ' .. cargo_path)
  else
    local git_dir
    for dir in vim.fs.parents(vim.api.nvim_buf_get_name(0)) do
      if vim.fn.isdirectory(dir .. '/.git') == 1 then
        git_dir = dir
        break
      end
    end

    if git_dir then
      vim.cmd('e ' .. vim.fs.joinpath(git_dir, filename))
    end
  end
end

function find_file_from_here(filename)
  local dir
  for check in vim.fs.parents(vim.api.nvim_buf_get_name(0)) do
    if vim.fn.filereadable(vim.fs.joinpath(check, filename)) == 1 then
      dir = check
      break
    end
  end

  if dir then
    vim.cmd('e ' .. vim.fs.joinpath(dir, filename))
  end
end

function compare_fields_top(entry1, entry2)
  local types = require 'cmp.types'
  local kind1 = entry1:get_kind() --- @type lsp.CompletionItemKind | number
  local kind2 = entry2:get_kind() --- @type lsp.CompletionItemKind | number
  kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
  kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
  kind1 = kind1 == types.lsp.CompletionItemKind.Field and 0 or kind1
  kind2 = kind2 == types.lsp.CompletionItemKind.Field and 0 or kind2
  if kind1 ~= kind2 then
    if kind1 == types.lsp.CompletionItemKind.Field then
      return true
    end
    if kind2 == types.lsp.CompletionItemKind.Field then
      return false
    end
    local diff = kind1 - kind2
    if diff < 0 then
      return true
    elseif diff > 0 then
      return false
    end
  end
  return nil
end
-- autocommands
local function augroup(name)
  return vim.api.nvim_create_augroup('lazyvim_' .. name, { clear = true })
end

--  TODO: create autocommand to re-evaluate the quickfix diagnostics list on save

--
-- close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'close_with_q',
  pattern = {
    'PlenaryTestPopup',
    'checkhealth',
    'dbout',
    'gitsigns-blame',
    'grug-far',
    'help',
    'lspinfo',
    'neotest-output',
    'neotest-output-panel',
    'neotest-summary',
    'notify',
    'qf',
    'spectre_panel',
    'startuptime',
    'tsplayground',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set('n', 'q', function()
        vim.cmd 'close'
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = 'Quit buffer',
      })
    end)
  end,
})

-- vim.api.nvim_create_autocmd({ 'FileType' }, {
--   callback = function()
--     -- check if treesitter has parser
--     if require('nvim-treesitter.parsers').has_parser() then
--       -- use treesitter folding
--       vim.opt.foldmethod = 'expr'
--       -- vim.opt.foldtext = ''
--       vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
--     else
--       -- use alternative foldmethod
--       vim.opt.foldmethod = 'syntax'
--     end
--   end,
-- })
-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup 'checktime',
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd 'checktime'
    end
  end,
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
--
