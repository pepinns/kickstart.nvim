-- Flash.nvim configuration - Jump to any location quickly (similar to avy in emacs)
-- This plugin allows you to navigate to any visible text with a few keystrokes

-- ===========================
-- HOTKEY CONFIGURATION SECTION
-- ===========================
-- Edit these to customize your keybindings and avoid conflicts
-- Set to nil or false to disable individual bindings

local flash_config = {
  -- Enable/disable flash.nvim entirely
  enabled = true,

  -- Main jump keybindings (jump to any visible text with labels)
  -- Similar to avy-goto-char-2 in emacs
  jump_key = 's', -- Press 's' then type characters to jump (works in normal, visual, operator-pending modes)
  jump_line_key = 'S', -- Press 'S' to jump to any line (works in normal, visual, operator-pending modes)

  -- Treesitter-based navigation (jump to language constructs like functions, classes, etc.)
  -- Similar to avy-goto-word in emacs but smarter with syntax awareness
  treesitter_key = nil, -- Set to a key like 'T' to enable treesitter jump, or nil to disable

  -- Remote flash - for advanced usage (yank/delete/change text at distance)
  -- Similar to avy-copy-line or avy-kill-whole-line in emacs
  remote_key = nil, -- Set to a key like 'r' (in operator-pending mode) to enable, or nil to disable

  -- Treesitter search - search with treesitter awareness
  treesitter_search_key = nil, -- Set to a key like 'R' to enable, or nil to disable

  -- Toggle flash search in command mode (enhances / and ? searches)
  toggle_search_key = '<c-s>', -- Press Ctrl+S during search to toggle flash labels, or nil to disable

  -- Flash options
  opts = {
    -- Label appearance and behavior
    labels = 'asdfghjklqwertyuiopzxcvbnm', -- Characters used for jump labels (most common keys under fingers)
    search = {
      -- Search mode behavior
      mode = 'exact', -- exact: exact match only, search: regular search, fuzzy: fuzzy match with scoring
      incremental = false, -- Show labels after first character
      multi_window = true, -- Search across all visible windows
    },
    jump = {
      -- Jump behavior
      jumplist = true, -- Add jumps to jumplist
      pos = 'start', -- Jump to start, end, or range of match
      offset = nil, -- Offset to add to the jump position
      nohlsearch = false, -- Clear search highlight after jump
      autojump = false, -- Automatically jump if only one match
    },
    label = {
      -- Label display options
      uppercase = true, -- Show labels in uppercase
      rainbow = {
        enabled = false, -- Use rainbow colors for labels
        shade = 5, -- Shade of rainbow colors (1-9)
      },
    },
    modes = {
      -- Disable default f/F/t/T behavior (keep vim's native behavior)
      -- Set to {} to disable flash for these operations
      char = {
        enabled = false, -- Don't hijack f/F/t/T keys
        keys = {}, -- Empty to keep default vim behavior
      },
    },
    -- Prompt for flash search
    prompt = {
      enabled = true,
      prefix = { { '⚡', 'FlashPromptIcon' } }, -- Icon shown in prompt
    },
  },
}

-- ===========================
-- PLUGIN SETUP (Don't edit below unless you know what you're doing)
-- ===========================

if not flash_config.enabled then
  return {}
end

local keys = {}

-- Add jump key if configured
if flash_config.jump_key then
  table.insert(keys, {
    flash_config.jump_key,
    mode = { 'n', 'x', 'o' },
    function()
      require('flash').jump()
    end,
    desc = 'Flash Jump (jump to any text)',
  })
end

-- Add line jump key if configured
if flash_config.jump_line_key then
  table.insert(keys, {
    flash_config.jump_line_key,
    mode = { 'n', 'x', 'o' },
    function()
      require('flash').jump {
        search = { mode = 'search', max_length = 0 },
        label = { after = { 0, 0 } },
        pattern = '^',
      }
    end,
    desc = 'Flash Jump Line (jump to any line)',
  })
end

-- Add treesitter key if configured
if flash_config.treesitter_key then
  table.insert(keys, {
    flash_config.treesitter_key,
    mode = { 'n', 'x', 'o' },
    function()
      require('flash').treesitter()
    end,
    desc = 'Flash Treesitter (jump to syntax nodes)',
  })
end

-- Add remote key if configured (operator-pending mode only)
if flash_config.remote_key then
  table.insert(keys, {
    flash_config.remote_key,
    mode = 'o',
    function()
      require('flash').remote()
    end,
    desc = 'Flash Remote (operate on distant text)',
  })
end

-- Add treesitter search key if configured
if flash_config.treesitter_search_key then
  table.insert(keys, {
    flash_config.treesitter_search_key,
    mode = { 'x', 'o' },
    function()
      require('flash').treesitter_search()
    end,
    desc = 'Flash Treesitter Search',
  })
end

-- Add toggle search key if configured (command mode)
if flash_config.toggle_search_key then
  table.insert(keys, {
    flash_config.toggle_search_key,
    mode = { 'c' },
    function()
      require('flash').toggle()
    end,
    desc = 'Toggle Flash Search',
  })
end

return {
  'folke/flash.nvim',
  event = 'VeryLazy',
  opts = flash_config.opts,
  keys = keys,
}

