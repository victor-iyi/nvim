-- Fuzzy finding. Global maps (<leader>ff/fs/fc/fb/fh) are in `config/keymaps.lua`.
local telescope = require('telescope')
local actions = require('telescope.actions')

-- Shared by file listing and grep so both skip the same noise.
local ignore_globs = {
  '--glob=!**/.git/*',
  '--glob=!**/.idea/*',
  '--glob=!**/.vscode/*',
  '--glob=!**/.venv/*',
  '--glob=!**/build/*',
  '--glob=!**/dist/*',
  '--glob=!**/target/*',
  '--glob=!**/node_modules/*',
  '--glob=!**/package-lock.json',
}

telescope.setup({
  defaults = {
    prompt_prefix = ' \u{f002}  ',
    selection_caret = '\u{f054} ',
    sorting_strategy = 'ascending',
    layout_config = {
      horizontal = { prompt_position = 'top', preview_width = 0.55 },
      width = 0.87,
      height = 0.80,
    },
    path_display = { 'filename_first' },
    vimgrep_arguments = vim.list_extend({
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case',
      '--hidden',
    }, ignore_globs),
    mappings = {
      i = {
        ['<C-k>'] = actions.move_selection_previous,
        ['<C-j>'] = actions.move_selection_next,
        ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
        ['<Esc>'] = actions.close,
      },
    },
  },
  pickers = {
    find_files = {
      hidden = true,
      find_command = vim.list_extend({ 'rg', '--files', '--hidden' }, ignore_globs),
    },
    buffers = { sort_mru = true, ignore_current_buffer = true },
  },
})

pcall(telescope.load_extension, 'fzf')
