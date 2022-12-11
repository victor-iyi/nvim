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

-- leader key.
vim.g.mapleader = ' '

local keymap = vim.keymap -- Alias for vim.api.nvim_set_keymap

-- General keymaps.
keymap.set({ 'i', 'v' }, '<C-j>', '<ESC>') -- Escape from insert/visual mode.
keymap.set({ 'i', 'v' }, '<C-k>', '<ESC>') -- Escape from insert/visual mode.
keymap.set('n', '<leader>w', ':w<CR>') -- Save file.

keymap.set('', 'H', '^') -- Move cursor to begining of line.
keymap.set('', 'L', '$') -- Move cursor to end of line.

-- Disable arrow keys.
-- Disable in insert/normal mode.
keymap.set({ 'i', 'n' }, '<up>', '<nop>')
keymap.set({ 'i', 'n' }, '<down>', '<nop>')
keymap.set('i', '<left>', '<nop>')
keymap.set('i', '<right>', '<nop>')

-- Disable <F1> key
keymap.set({ '', 'i' }, '<F1>', '<nop>')

-- Copy to clipboard
keymap.set('v', '<leader>y', '"+y') -- Copy selected text to clipboard.
keymap.set('n', '<leader>p', '"+p') -- Paste from clipboard.
keymap.set('n', '<leader>P', '"+P') -- Paste above line.
keymap.set('v', 'p', '_dP') -- paste without replacing buffer contents.
keymap.set('v', '<leader>=', '<C-W><C-=>') -- Re-indent word until whitespace.

-- Switch buffers.
keymap.set('n', '<leader><leader>', '<C-^>') -- Toggle between buffers.
keymap.set('n', '<left>', ':bp<CR>') -- Move to previous buffer.
keymap.set('n', '<right>', ':bn<CR>') -- Move to next buffer.

-- Center search results.
keymap.set('n', 'n', 'nzz', { silent = true })
keymap.set('n', 'N', 'Nzz', { silent = true })
keymap.set('n', '*', '*zz', { silent = true })
keymap.set('n', '#', '#zz', { silent = true })
keymap.set('n', 'g*', 'g*zz', { silent = true })

-- Center while navigating half-page.
keymap.set('n', '<C-d>', '<C-d>zz', { silent = true })
keymap.set('n', '<C-u>', '<C-u>zz', { silent = true })

-- Center your cursor
-- zz = center of the window
-- zt = top of the window
-- zb = bottom of the window

-- Search & replace (very magic by default)
-- keymap.set('n', '?', '?\v')
-- keymap.set('n', '/', '/\v')
-- keymap.set('c', '%s/', '%sm/')

-- clear search highlight
keymap.set('n', '<leader>nh', ':nohl<CR>')

-- Delete without yanking.
keymap.set('n', 'x', '"_x')

-- Increment and decrement numbers.
keymap.set('n', '<leader>+', '<C-a>')
keymap.set('n', '<leader>-', '<C-x>')

-- Split windows.
keymap.set('n', '<leader>sv', '<C-w>v') -- Vertical split.
keymap.set('n', '<leader>sh', '<C-w>s') -- Horizontal split.
keymap.set('n', '<leader>se', '<C-w>=') -- Make split windows equal width..
keymap.set('n', '<leader>sx', ':close<CR>') -- Close current split.

-- Window resize.
keymap.set('n', '<leader>v+', ':vertical resize +5<CR>', { silent = true })
keymap.set('n', '<leader>v-', ':vertical resize -6<CR>', { silent = true })
keymap.set('n', '<leader>vr', ':vertical resize 30<CR>', { silent = true })

-- Managing tabs.
keymap.set('n', '<leader>to', ':tabnew<CR>') -- Open new tab.
keymap.set('n', '<leader>tx', ':tabclose<CR>') -- Close current tab.
keymap.set('n', '<leader>tn', ':tabnext<CR>') -- Next tab.
keymap.set('n', '<leader>tp', ':tabprevious<CR>') -- Previous tab.

-- Move line up or down.
-- keymap.set('n', '<A-j>', ':m .+1<CR>==')
-- keymap.set('n', '<A-k>', ':m .-2<CR>==')
-- keymap.set('i', 'J', '<ESC>:m .+1<CR>==gi')
-- keymap.set('i', 'K', '<ESC>:m .-2<CR>==gi')
keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
keymap.set('v', 'K', ":m '<-2<CR>gv=gv")

-- Plugin keymaps

-- vim-maximizer
keymap.set('n', '<leader>sm', ':MaximizerToggle!<CR>')

-- undo-tree
keymap.set('n', '<leader>u', ':UndotreeToggle<CR>')

-- nvim-tree
keymap.set('n', '<leader>pt', ':NvimTreeToggle<CR>')

-- NERDTree
-- keymap.set('n', '<leader>pt', ':NERDTreeToggle<CR>')
--
-- Formatter.
keymap.set('n', '<leader>f', ':Format<CR>', { silent = true })
keymap.set('n', '<leader>F', ':FormatWrite<CR>', { silent = true })
