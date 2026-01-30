# Flash.nvim Setup Guide

This branch has flash.nvim configured with explicit keybindings similar to avy in emacs. This guide explains how to use and customize it.

## What is flash.nvim?

Flash.nvim is a motion plugin that allows you to jump to any visible location quickly with just a few keystrokes. It's similar to avy in emacs or hop.nvim/leap.nvim in neovim.

## Default Keybindings

### Main Navigation (Enabled by Default)

- **`gm`** - Flash Jump: Jump to any visible text
  - Press `gm`, then type 1-2 characters you want to jump to
  - Labels will appear at all matches
  - Type the label to jump there
  - Works in normal, visual, and operator-pending modes
  - **Note**: Changed from `s` to `gm` to avoid conflict with nvim-surround

- **`gM`** - Flash Jump Line: Jump to any line
  - Press `gM` to see labels at the start of each line
  - Type the label to jump to that line
  - Works in normal, visual, and operator-pending modes
  - **Note**: Changed from `S` to `gM` to avoid conflict with nvim-surround

- **`<Ctrl-s>`** - Toggle Flash Search (in command mode)
  - While using `/` or `?` to search, press `<Ctrl-s>` to show flash labels at all matches
  - Makes it easy to jump to any search result

### Advanced Features (Disabled by Default)

These are disabled to avoid conflicts. Enable them by editing the config (see below):

- **Treesitter Jump** - Jump to syntax-aware nodes (functions, classes, etc.)
- **Remote Flash** - Operate (yank/delete/change) on text at a distance
- **Treesitter Search** - Search with treesitter awareness

## Usage Examples

### Example 1: Quick Character Jump (like avy-goto-char-2)
1. Press `gm`
2. Type `fu` (first two characters of "function")
3. Labels appear at all "fu" matches
4. Type the label letter to jump there

### Example 2: Jump to Any Line (like avy-goto-line)
1. Press `gM`
2. Labels appear at the start of each visible line
3. Type the label to jump to that line

### Example 3: Visual Selection with Flash
1. Press `v` to enter visual mode
2. Press `gm`, then type characters to jump
3. Your selection extends to the jump target

### Example 4: Operator + Flash (e.g., delete to target)
1. Press `d` to start delete operation
2. Press `gm`, then type characters
3. Text from cursor to target gets deleted

### Example 5: Enhanced Search
1. Press `/` to start a search
2. Type your search pattern
3. Press `<Ctrl-s>` to show flash labels at all matches
4. Type a label to jump directly to that match

## Customization

All configuration is in `lua/plugins/flash.lua` at the top of the file in the `flash_config` table.

### Changing Keybindings

Edit these values in the `flash_config` table:

```lua
local flash_config = {
  enabled = true,              -- Set to false to disable flash entirely
  
  jump_key = 'gm',             -- Current: 'gm' (or change to your preferred key, or nil to disable)
  jump_line_key = 'gM',        -- Current: 'gM' (or change to your preferred key, or nil to disable)
  
  treesitter_key = nil,        -- Set to 'T' or another key to enable
  remote_key = nil,            -- Set to 'r' or another key to enable
  treesitter_search_key = nil, -- Set to 'R' or another key to enable
  toggle_search_key = '<c-s>', -- Change or set to nil to disable
  
  -- ... rest of config ...
}
```

**Note**: The default keys were changed from `s`/`S` to `gm`/`gM` to avoid conflicts with nvim-surround. Other good alternatives include:
- `<leader>j` and `<leader>J` (leader + jump)
- `;` and `,` (if you don't use them to repeat f/F/t/T)
- `m` and `M` (if you don't use marks frequently)

### Examples of Different Keybinding Setups

#### Setup 1: Minimal (Just Basic Jump)
```lua
jump_key = 'gm',
jump_line_key = nil,         -- Disable line jump
toggle_search_key = nil,     -- Disable search toggle
```

#### Setup 2: All Features Enabled
```lua
jump_key = 'gm',
jump_line_key = 'gM',
treesitter_key = 'T',
remote_key = 'r',
treesitter_search_key = 'R',
toggle_search_key = '<c-s>',
```

#### Setup 3: Alternative Keys with Leader
```lua
jump_key = '<leader>j',      -- Leader + j (Space + j if leader is Space)
jump_line_key = '<leader>J', -- Leader + J (Space + J if leader is Space)
treesitter_key = '<leader>t',
toggle_search_key = '<c-f>', -- Ctrl+f in search
```

### Customizing Flash Behavior

The `opts` section in `flash_config` controls how flash behaves:

```lua
opts = {
  labels = 'asdfghjklqwertyuiopzxcvbnm', -- Characters used for labels
  search = {
    mode = 'exact',           -- 'exact', 'search', or 'fuzzy'
    incremental = false,      -- Show labels after first character
    multi_window = true,      -- Search across all windows
  },
  jump = {
    jumplist = true,          -- Add jumps to jumplist (Ctrl-o to go back)
    autojump = false,         -- Jump automatically if only one match
  },
  -- ... more options available ...
}
```

## Comparison with Avy (Emacs)

| Avy (Emacs) | Flash.nvim | Description |
|-------------|------------|-------------|
| `avy-goto-char-2` | `gm` (then 2 chars) | Jump to any two characters |
| `avy-goto-line` | `gM` | Jump to any line |
| `avy-goto-word-1` | `gm` (then word start) | Jump to word beginning |
| `avy-copy-line` | `remote_key` (disabled) | Operate on remote text |

## Troubleshooting

### Issue: Keybinding Conflicts
**Solution**: Edit `flash_config` in `lua/plugins/flash.lua` and change the conflicting keys to something else.

### Issue: Flash isn't working
**Solution**: 
1. Check that `enabled = true` in the config
2. Restart neovim
3. Run `:Lazy sync` to ensure plugins are loaded

### Issue: Labels are hard to see
**Solution**: Adjust label options in the config:
```lua
label = {
  uppercase = true,  -- Try changing this
  rainbow = {
    enabled = true,  -- Enable rainbow colors
  },
}
```

### Issue: Don't want flash to work in certain modes
**Solution**: Modify the `mode` parameter for specific keybindings. For example, to only enable flash in normal mode:
```lua
jump_key = 'gm',  -- Keep this, then in the setup code change:
-- mode = { 'n', 'x', 'o' },  -- Original
-- to:
-- mode = { 'n' },  -- Only normal mode
```

## Additional Resources

- [Flash.nvim GitHub](https://github.com/folke/flash.nvim)
- [Flash.nvim Documentation](https://github.com/folke/flash.nvim#-usage)
- [Avy for Emacs](https://github.com/abo-abo/avy) (for comparison)

## Quick Reference Card

```
Motion Commands:
  gm        Flash jump to any text (type 2 chars + label)
  gM        Flash jump to any line (type label)
  
In Search (/ or ?):
  <C-s>     Toggle flash labels on search results

Visual/Operator Modes:
  v + gm    Extend selection to target
  d + gm    Delete to target
  c + gm    Change to target
  y + gm    Yank to target
```

