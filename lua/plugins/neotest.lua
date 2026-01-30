return {

  {
    'nvim-neotest/neotest',
    dir = '~/pjs/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      's1n7ax/nvim-window-picker',
      'mfussenegger/nvim-dap',
    },
    opts = {
      status = { virtual_text = true },
      output_panel = {
        enabled = true,
        open = 'botright vsplit | vertical resize 80',
      },
      output = {
        enabled = true,
        open_on_run = true,
        open_enter_on_run = true,
      },
    },
  -- stylua: ignore
    keys = {
      {
        "<localleader>tt",
        function()
          local l, c = unpack(vim.api.nvim_win_get_cursor(0))
          vim.api.nvim_buf_set_mark(0, "T", l, c, {})
          local nt = require("neotest")
          nt.run.run()
          nt.summary.open()
        end,
      },
      {
        "<localleader>tl",
        function()
          require("neotest").run.run_last()
        end, desc = "Run Last Test"
      },
      { "<leader>te", function() vim.diagnostic.open_float(0, {scope = "line"}) end, desc="Open Line Diagnostic" },
      { "<leader>t", "", desc = "+test"},
      { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run File (Neotest)" },
      { "<leader>tT", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run All Test Files (Neotest)" },
      { "<leader>tr", function() require("neotest").run.run() end, desc = "Run Nearest (Neotest)" },
      { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run Last (Neotest)" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle Summary (Neotest)" },
      { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output (Neotest)" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle Output Panel (Neotest)" },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop (Neotest)" },
      { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle Watch (Neotest)" },
      { "<leader>td", function() require("neotest").run.run({strategy = "dap"}) end, desc = "Debug Nearest" },
    },
  },
  {
    'mfussenegger/nvim-dap',
    desc = 'Debugging support. Requires language specific adapters to be configured. (see lang extras)',

    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-neotest/nvim-dap-ui',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      -- virtual text for the debugger
      {
        'theHamsta/nvim-dap-virtual-text',
        opts = {},
      },
    },

    -- stylua: ignore
    keys = {
      { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Run/Continue" },
      { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
      { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>dj", function() require("dap").down() end, desc = "Down" },
      { "<leader>dk", function() require("dap").up() end, desc = "Up" },
      { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dP", function() require("dap").pause() end, desc = "Pause" },
      { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
      { "<leader>ds", function() require("dap").session() end, desc = "Session" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
      { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
    },
    config = function()
      vim.api.nvim_set_hl(0, 'DapStoppedLine', { default = true, link = 'Visual' })
      icons = {
        Stopped = { 'U ', 'DiagnosticWarn', 'DapStoppedLine' },
        Breakpoint = ' ',
        BreakpointCondition = ' ',
        BreakpointRejected = { ' ', 'DiagnosticError' },
        LogPoint = '.>',
      }
      for name, sign in pairs(icons) do
        sign = type(sign) == 'table' and sign or { sign }
        vim.fn.sign_define('Dap' .. name, { text = sign[1], texthl = sign[2] or 'DiagnosticInfo', linehl = sign[3], numhl = sign[3] })
      end
    end,
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = {
      { 'mason-org/mason.nvim', opts = {} },
    },
    ft = { 'rust', 'c', 'c++' },
    config = function()
      -- Note: mason-tool-installer will automatically install codelldb if missing
      require('mason-tool-installer').setup { ensure_installed = { 'codelldb' } }
      
      -- Use mason-registry to dynamically get the codelldb installation path
      local mason_registry = require('mason-registry')
      
      -- Function to setup DAP after codelldb is ready
      local function setup_codelldb_dap()
        if not mason_registry.is_installed('codelldb') then
          return false, 'not_installed'
        end
        
        local package_path = mason_registry.get_package('codelldb'):get_install_path()
        local codelldb_path = package_path .. '/extension/adapter/codelldb'
        
        -- Verify the codelldb binary exists and is executable
        if vim.fn.executable(codelldb_path) == 0 then
          -- Check architecture for ARM-specific issues
          -- NOTE: Mason's codelldb does not support ARM Linux (aarch64/arm64)
          -- If you're on ARM Linux:
          --   1. Download codelldb from https://github.com/vadimcn/codelldb/releases
          --   2. Extract it to a location (e.g., ~/.local/share/codelldb)
          --   3. Update codelldb_path below to point to your installation
          --   4. Example: local codelldb_path = vim.fn.expand('~/.local/share/codelldb/adapter/codelldb')
          local arch_handle = io.popen('uname -m')
          local is_arm = false
          if arch_handle then
            local arch = arch_handle:read '*l'
            arch_handle:close()
            is_arm = (arch == 'aarch64' or arch == 'arm64')
          end
          
          local error_msg = 'codelldb binary not found or not executable at: ' .. codelldb_path
          if is_arm then
            error_msg = error_msg .. '\n' ..
              'Mason\'s codelldb does not support ARM Linux. ' ..
              'Please install codelldb manually from: https://github.com/vadimcn/codelldb/releases'
          end
          vim.notify(error_msg, vim.log.levels.ERROR)
          return false, 'not_executable'
        end
        
        local library_path = package_path .. '/extension/lldb/lib/liblldb.dylib'
        local uname_handle = io.popen('uname')
        if uname_handle then
          local uname = uname_handle:read '*l'
          uname_handle:close()
          if uname == 'Linux' then
            library_path = package_path .. '/extension/lldb/lib/liblldb.so'
          end
        else
          -- If we can't determine OS, provide a warning and use platform-specific fallback
          vim.notify('Warning: Unable to detect OS. Using default library path.', vim.log.levels.WARN)
        end
        
        local dap = require 'dap'
        dap.adapters.codelldb = {
          type = 'server',
          port = '${port}',
          host = '127.0.0.1',
          executable = {
            command = codelldb_path,
            args = { '--liblldb', library_path, '--port', '${port}' },
          },
        }
        for _, lang in ipairs { 'rust' } do
          dap.configurations[lang] = {
            {
              type = 'codelldb',
              request = 'launch',
              name = 'Launch file',
              program = function()
                return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
              end,
              cwd = '${workspaceFolder}',
            },
            {
              type = 'codelldb',
              request = 'attach',
              name = 'Attach to process',
              pid = require('dap.utils').pick_process,
              cwd = '${workspaceFolder}',
            },
          }
        end
        return true, 'success'
      end
      
      -- Try to setup immediately
      local success, reason = setup_codelldb_dap()
      if not success then
        if reason == 'not_installed' then
          -- Only wait for installation if codelldb isn't installed yet
          vim.notify('codelldb is being installed by mason-tool-installer. DAP will be configured when ready.', vim.log.levels.INFO)
          
          -- Listen for package installation events (only register once)
          local event_registered = false
          if mason_registry:has_package('codelldb') and not event_registered then
            mason_registry.get_package('codelldb'):once('install:success', function()
              local retry_success = setup_codelldb_dap()
              if retry_success then
                vim.notify('codelldb installation complete. DAP configured successfully.', vim.log.levels.INFO)
              end
            end)
            event_registered = true
          end
        end
        -- If reason is 'not_executable', the error was already shown in setup_codelldb_dap
      end
    end,
  },
  -- fancy UI for the debugger
  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-neotest/nvim-nio',
    },
    -- stylua: ignore
    keys = {
      { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
      { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
    },
    opts = {},
    config = function(_, opts)
      local dap = require 'dap'
      local dapui = require 'dapui'
      dapui.setup(opts)
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open {}
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close {}
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close {}
      end
    end,
  },
}
