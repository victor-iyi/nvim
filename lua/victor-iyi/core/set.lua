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

-- vim configuration options.
local opt = vim.opt

-- vim global configuration options.
local g = vim.g

-- Check if we're on MacOs.
local is_macos = vim.loop.os_uname().sysname == 'Darwin'

-- Use language-specific plugins for indenting.
vim.cmd('filetype plugin indent on')

-- appearance settings
opt.guicursor = 'n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor'
opt.termguicolors = true
opt.background = 'dark'
opt.colorcolumn = '80' -- Show line length marker at 80 columns.
opt.showcmd = true -- Show (partial) command in status line.
opt.mouse = 'a' -- Enable (all modes) mouse support.

-- line numbers.
opt.relativenumber = true
opt.number = true

opt.backspace = 'indent,eol,start' -- Backspace over everything in insert mode.
opt.foldenable = false -- Disable folding.
opt.ttyfast = true -- Faster terminal output.
opt.lazyredraw = true -- Don't redraw while executing macros (good performance config).
opt.laststatus = 2 -- Always show the status line.

opt.errorbells = false

-- clipboard settings
opt.clipboard = 'unnamedplus' -- Copy/paste between vim and everything else.
-- opt.clipboard = 'unnamed' -- Copy/paste between vim and everything else.

-- tab settings.
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smarttab = true
opt.smartindent = true
opt.autoindent = true

-- line wrapping
opt.wrap = false

-- Time to wait for a mapped sequence to complete.
-- ie. perform all vim motions in less than 2 secs.
opt.timeoutlen = 1000

opt.encoding = 'utf-8'
opt.scrolloff = 8
opt.hidden = true
opt.showmode = false
opt.joinspaces = false

-- Always show the sign column. Otherwise it would shift
-- the text each time diagnostics appear/become resolved.
opt.signcolumn = 'yes'

-- Settings needed for .lvimrc
opt.exrc = true
opt.secure = true

-- Sane splits
opt.splitright = true
opt.splitbelow = true

-- Decent wildmenu
opt.wildmode = 'list:longest'
opt.wildignore =
  '.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,.DS_Store,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor'

-- Show those damn hidden characters
-- Verbose: opt.listchars = 'nbsp:¬,eol:¶,extends:»,precedes:«,trail:•'
opt.listchars = 'nbsp:¬,extends:»,precedes:«,trail:•'

-- swap files.
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undodir = os.getenv('HOME') .. '/.cache/nvim/undo'
opt.undofile = true

-- search settings
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.gdefault = true

-- Give more space for displaying messages.
opt.cmdheight = 2

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
opt.updatetime = 300

opt.iskeyword:append('-')

-- Don't pass messages to |ins-completion-menu|.
opt.shortmess:append('c')

-- Wrapping options.
opt.formatoptions:append('tc') -- Wrap text and comments using textwidth
opt.formatoptions:append('r') -- Continue comments when pressing ENTER in I mode
opt.formatoptions:append('q') -- Allow formatting comments w/ gq
opt.formatoptions:append('n') -- Detect list for formatting
opt.formatoptions:append('b') -- Auto-wrap insert mode, and do not wrap old long lines

-- Plugins

-- NERDTree
g.webdevicons_enable_nerdtree = 1

-- Rust
-- g.rustfmt_autosave = 1
if is_macos then
  g.rust_clip_command = 'pbcopy'
else
  g.rust_clip_command = 'xclip -selection clipboard'
end

-- CoC (Conquer of Completion)
local ext_ok, ext = pcall(require, 'victor-iyi.utils.coc-extensions')
if not ext_ok then
  -- Use essential extensions.
  g.coc_global_extensions = {
    'coc-rust-analyzer',
    'coc-pyright',
    'coc-sumneko-lua',
    'coc-tsserver',
    'coc-sh',
    'coc-docker',
    'coc-markdownlint',
    'coc-markdown-preview-enhanced',
    'coc-diagnostic',
    'coc-git',
    'coc-highlight',
    'coc-json',
    'coc-yaml',
    'coc-toml',
  }
else
  -- Use all listed extensions.
  g.coc_global_extensions = ext.extensions
end

-- specify node path on Linux.
if not is_macos then
  g.coc_node_path = '/snap/bin/node'
end

-- GitHub copilot
g.copilot_no_tab_map = true
