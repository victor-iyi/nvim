-- Neovim 0.12+ configuration.
--
-- Load order matters: leader before any mapping, options before plugins (so plugin
-- scripts see final values), plugins on the runtimepath before anything requires them.

if vim.fn.has('nvim-0.12') == 0 then
  vim.api.nvim_echo({ { 'This config requires Neovim 0.12+', 'ErrorMsg' } }, true, {})
  return
end

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Byte-compile and cache every required Lua module.
vim.loader.enable()

require('config.options')
require('config.keymaps')
require('config.autocmds')
require('config.pack')
require('config.diagnostics')

-- UI first so later plugins pick up the colorscheme's highlight groups.
require('plugins.ui')
require('plugins.editor')
require('plugins.treesitter')
require('plugins.explorer')
require('plugins.telescope')
require('plugins.terminal')
require('plugins.git')
require('plugins.completion')
require('plugins.copilot')
require('plugins.lsp')
require('plugins.format')
require('plugins.lint')
require('plugins.lang')
require('plugins.dap')

-- Last: needs completion capabilities and Mason's PATH entry in place.
require('config.lsp')
