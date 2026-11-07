-- Editing helpers. Plugins configured through `g:` variables are set here during init,
-- before their `plugin/` scripts are sourced.

require('Comment').setup()
require('nvim-surround').setup()
require('nvim-autopairs').setup({ check_ts = true })

-- Show the matching line in a popup when its pair is off screen.
vim.g.matchup_matchparen_offscreen = { method = 'popup' }
vim.g.matchup_matchparen_deferred = 1

-- vim-tmux-navigator keeps its default maps: <C-h/j/k/l> and <C-\>.
vim.g.tmux_navigator_disable_when_zoomed = 1

vim.g.rooter_silent_chdir = 1

vim.g.undotree_SetFocusWhenToggle = 1
vim.g.undotree_WindowLayout = 2
