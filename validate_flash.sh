#!/usr/bin/env bash
# Simple validation script for flash.nvim configuration
# This script checks if the Lua configuration is valid

set -e

echo "=== Flash.nvim Configuration Validation ==="
echo ""

# Check if the file exists
if [ ! -f "lua/plugins/flash.lua" ]; then
    echo "❌ ERROR: lua/plugins/flash.lua not found"
    exit 1
fi

echo "✓ flash.lua file exists"

# Check if the file has the expected configuration structure
if grep -q "local flash_config" lua/plugins/flash.lua; then
    echo "✓ flash_config table found"
else
    echo "❌ ERROR: flash_config table not found"
    exit 1
fi

# Check if main keybindings are defined
if grep -q "jump_key" lua/plugins/flash.lua; then
    echo "✓ jump_key configuration found"
else
    echo "❌ ERROR: jump_key configuration not found"
    exit 1
fi

if grep -q "jump_line_key" lua/plugins/flash.lua; then
    echo "✓ jump_line_key configuration found"
else
    echo "❌ ERROR: jump_line_key configuration not found"
    exit 1
fi

# Check if the file returns a proper plugin spec
if grep -q "return {" lua/plugins/flash.lua; then
    echo "✓ Plugin spec return statement found"
else
    echo "❌ ERROR: Plugin spec return statement not found"
    exit 1
fi

# Check if flash.nvim plugin is referenced
if grep -q "folke/flash.nvim" lua/plugins/flash.lua; then
    echo "✓ flash.nvim plugin reference found"
else
    echo "❌ ERROR: flash.nvim plugin reference not found"
    exit 1
fi

echo ""
echo "=== Configuration Summary ==="
echo ""

# Extract and display the current keybindings
echo "Enabled keybindings:"
grep -E "^\s*(jump_key|jump_line_key|treesitter_key|remote_key|treesitter_search_key|toggle_search_key)" lua/plugins/flash.lua | sed 's/^/  /'

echo ""
echo "✅ All validation checks passed!"
echo ""
echo "To customize keybindings, edit the flash_config table in lua/plugins/flash.lua"
echo "For usage instructions, see FLASH_SETUP.md"

