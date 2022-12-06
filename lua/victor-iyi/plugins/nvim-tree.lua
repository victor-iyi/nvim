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

-- nvim-tree
-- URL: https://github.com/nvim-tree/nvim-tree.lua
local status, tree = pcall(require, 'nvim-tree')
if not status then
  return
end

tree.setup()
-- examples for your init.lua

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- empty setup using defaults
-- tree.setup()

-- OR setup with some options
tree.setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = 'u', action = 'dir_up' },
        { key = 's', action = 'vsplit' },
        { key = 'i', action = 'split' },
        { key = '?', action = 'toggle_help' },
        { key = 'go', action = 'preview' },
        { key = 'cd', action = 'cd' },
        { key = '<C-j>', action = 'next_sibling' },
        { key = '<C-k>', action = 'prev_sibling' },
        { key = 'X', action = 'collapse_all' },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    --- hide dotfiles.
    dotfiles = true,
  },
  actions = {
    open_file = {
      window_picker = {
        enable = false,
      },
    },
  },
})
