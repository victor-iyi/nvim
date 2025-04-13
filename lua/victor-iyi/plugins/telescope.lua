-- Copyright 2022 Victor I. Afolabi
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--     http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

-- telescope
-- URL: https://github.com/nvim-lualine/lualine.nvim
local status, telescope = pcall(require, 'telescope')
if not status then
  return
end

local builtin_status, builtin = pcall(require, 'telescope.builtin')
if not builtin_status then
  return
else
  -- Keymaps.
  local keymap = vim.keymap.set
  keymap('n', '<leader>ff', builtin.find_files) -- find files in project
  keymap('n', '<leader>fs', builtin.live_grep) -- find string in project
  keymap('n', '<leader>fc', builtin.grep_string) -- find string in current file
  keymap('n', '<leader>fb', builtin.buffers)
  keymap('n', '<leader>fh', builtin.help_tags)
end

local action_status, actions = pcall(require, 'telescope.actions')
if not action_status then
  return
end

telescope.setup({
  defaults = {
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ['<C-k>'] = actions.move_selection_previous,
        ['<C-j>'] = actions.move_selection_next,
        ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
        ['<esc>'] = actions.close,
      },
    },
  },
  pickers = {
    -- Default configuration for builtin pickers goes here:
    -- picker_name = {
    --   picker_config_key = value,
    --   ...
    -- }
    -- Now the picker_config_key will be applied every time you call this
    -- builtin picker
    find_files = {
      -- theme = 'dropdown',
      -- previewer = false,
      hidden = true,
      find_command = {
        'rg',
        '--files',
        '--hidden',
        '--glob=!**/.git/*',
        '--glob=!**/.idea/*',
        '--glob=!**/.vscode/*',
        '--glob=!**/.venv/*',
        '--glob=!**/build/*',
        '--glob=!**/dist/*',
        '--glob=!**/package-lock.json',
      },
    },
  },
  extensions = {
    -- Your extension configuration goes here:
    -- extension_name = {
    --   extension_config_key = value,
    -- }
    -- please take a look at the readme of the extension you want to configure
  },
})

-- Load fzf
telescope.load_extension('fzf')
