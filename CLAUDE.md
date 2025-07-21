# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a LazyVim configuration for Neovim, built on the LazyVim starter template. LazyVim is a Neovim setup powered by lazy.nvim for plugin management.

## Key Commands

### Code Formatting
- `stylua .` - Format Lua code using the configured stylua settings (2-space indentation, 120 column width)

### Neovim Operations
- `nvim` - Start Neovim with this configuration
- `nvim +Lazy` - Open Neovim and launch the Lazy plugin manager interface
- `nvim +LazyHealth` - Check the health of LazyVim installation
- `nvim +checkhealth` - Run Neovim health checks

## Architecture

### Directory Structure
- `init.lua` - Entry point that bootstraps the configuration by requiring `config.lazy`
- `lua/config/` - Core configuration files
  - `lazy.lua` - Sets up lazy.nvim plugin manager and LazyVim
  - `options.lua` - Neovim options (currently uses LazyVim defaults)
  - `keymaps.lua` - Custom keybindings (currently uses LazyVim defaults)
  - `autocmds.lua` - Auto commands
- `lua/plugins/` - Plugin specifications
  - `example.lua` - Example plugin configurations (currently disabled with early return)

### Plugin Management
- Uses lazy.nvim as the plugin manager
- LazyVim provides the base configuration and plugin suite
- Plugins are automatically loaded from the `lua/plugins/` directory
- Configuration supports lazy-loading, version pinning, and automatic updates

### Configuration Philosophy
- Builds on LazyVim's opinionated defaults
- Custom plugins and overrides go in `lua/plugins/`
- LazyVim plugins can be extended, overridden, or disabled
- Uses modern Neovim features (Lua configuration, LSP, Treesitter)

### Default Tools
The example configuration shows common tools that would be installed:
- LSP servers (pyright, tsserver)
- Formatters and linters (stylua, shellcheck, shfmt, flake8)
- Treesitter parsers for syntax highlighting
- Telescope for fuzzy finding
- Mason for tool installation

### Customization Patterns
- Plugin specs in `lua/plugins/` can add new plugins, disable existing ones, or override configurations
- Use `opts` tables to merge configuration with defaults
- Use `opts` functions for more complex configuration logic
- Import LazyVim extras for language-specific configurations