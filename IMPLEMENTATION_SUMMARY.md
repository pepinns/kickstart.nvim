# Flash.nvim Integration - Summary

This branch (`copilot/enable-flash-with-hotkey-config`) has been configured with **flash.nvim** to provide avy-like navigation in Neovim.

## What's Been Done

### 1. **Enabled flash.nvim Plugin** 
   - File: `lua/plugins/flash.lua`
   - The plugin was already present but had all keybindings commented out
   - Now fully configured with explicit, customizable keybindings

### 2. **Default Keybindings (Active)**
   - **`gm`** - Flash Jump: Jump to any visible text by typing 2 characters
   - **`gM`** - Flash Line Jump: Jump to the start of any visible line
   - **`<C-s>`** - Toggle flash labels during search (`/` or `?`)
   - **Note**: Changed from `s`/`S` to `gm`/`gM` to avoid conflict with nvim-surround

### 3. **Optional Features (Disabled by Default)**
   These can be enabled by editing `lua/plugins/flash.lua`:
   - Treesitter-based jump (jump to syntax nodes like functions, classes)
   - Remote operations (yank/delete/change text at a distance)
   - Treesitter search

### 4. **Configuration Structure**
   All settings are in a single `flash_config` table at the top of `lua/plugins/flash.lua`:
   ```lua
   local flash_config = {
     enabled = true,           -- Master switch
     jump_key = 'gm',          -- Main jump key (changed from 's' to avoid nvim-surround conflict)
     jump_line_key = 'gM',     -- Line jump key (changed from 'S')
     treesitter_key = nil,    -- Disabled by default
     remote_key = nil,        -- Disabled by default
     toggle_search_key = '<c-s>',
     opts = { ... }           -- Detailed options
   }
   ```

### 5. **Documentation**
   - **FLASH_SETUP.md**: Comprehensive guide with:
     - Usage examples
     - Customization instructions
     - Comparison with emacs avy
     - Troubleshooting tips
     - Quick reference card

### 6. **Validation Script**
   - **validate_flash.sh**: Checks configuration syntax and displays current settings
   - Run with: `./validate_flash.sh`

## Quick Start

1. **Try it out**:
   ```
   nvim any_file.txt
   ```
   - Press `gm`, then type any 2 characters visible on screen
   - Labels will appear - type a label to jump there
   - Press `gM` to jump to any line

2. **Customize keybindings**:
   - Edit `lua/plugins/flash.lua`
   - Change values in the `flash_config` table at the top
   - Save and restart nvim

3. **Disable if needed**:
   - Set `enabled = false` in `flash_config`
   - Or set individual keys to `nil`

## Comparison with Avy (Emacs)

| Feature | Avy (Emacs) | Flash.nvim | Key |
|---------|-------------|------------|-----|
| Jump to characters | `avy-goto-char-2` | Flash Jump | `gm` |
| Jump to line | `avy-goto-line` | Flash Line Jump | `gM` |
| Jump during search | (varies) | Toggle Flash | `<C-s>` in search |
| Visual selection | Works with selections | Works with visual mode | `v` then `gm` |

## Key Design Decisions

1. **Explicit Configuration**: All keybindings are defined in one place at the top of the file
2. **Easy Disable**: Set any key to `nil` to disable that feature
3. **No Hijacking**: Doesn't override vim's native `f/F/t/T` keys by default
4. **Safe Defaults**: Advanced features disabled by default to avoid conflicts
5. **Clear Comments**: Every option is documented inline
6. **Conflict Avoidance**: Default keys changed from `s`/`S` to `gm`/`gM` to avoid nvim-surround conflict

## Files Changed

- `lua/plugins/flash.lua` - Main configuration (159 lines added)
- `FLASH_SETUP.md` - User documentation
- `validate_flash.sh` - Validation script

## Testing

Run the validation script to verify configuration:
```bash
./validate_flash.sh
```

Expected output:
```
✅ All validation checks passed!
```

## Next Steps

1. Try the default keybindings in neovim
2. Adjust keybindings in `lua/plugins/flash.lua` if needed
3. Read `FLASH_SETUP.md` for advanced usage
4. Enable optional features like treesitter jump if desired

## Troubleshooting

If flash doesn't work:
1. Restart neovim
2. Run `:Lazy sync` to update plugins
3. Check `:checkhealth` for any issues
4. Run `./validate_flash.sh` to verify configuration

For detailed help, see `FLASH_SETUP.md`.
