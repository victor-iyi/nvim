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

-- appearance settings
vim.opt.guicursor = 'n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor'
vim.opt.termguicolors = true
vim.opt.background = 'dark'
vim.opt.colorcolumn = '80'      -- Show line length marker at 80 columns.
vim.opt.showcmd = true          -- Show (partial) command in status line.
vim.opt.mouse = 'a'             -- Enable (all modes) mouse support.


-- line numbers.
vim.opt.relativenumber = true
vim.opt.number = true

vim.opt.backspace = 'indent,eol,start'  -- Backspace over everything in insert mode.
vim.opt.foldenable = false              -- Disable folding.
vim.opt.ttyfast = true                  -- Faster terminal output.
vim.opt.lazyredraw = true               -- Don't redraw while executing macros (good performance config).
vim.opt.laststatus = 2                  -- Always show the status line.

vim.opt.errorbells = false

-- clipboard settings
-- vim.opt.clipboard = 'unnamedplus'  -- Copy/paste between vim and everything else.

-- tab settings.
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.smarttab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

-- line wrapping
vim.opt.wrap = false

vim.opt.timeoutlen = 300
vim.opt.encoding = 'utf-8'
vim.opt.scrolloff = 8
vim.opt.hidden = true
vim.opt.showmode = false
vim.opt.joinspaces = false

vim.opt.printfont = ':h10'
vim.opt.printencoding = 'UTF-8'
vim.opt.printoptions = 'paper:letter'

-- Always show the sign column. Otherwise it would shift
-- the text each time diagnostics appear/become resolved.
vim.opt.signcolumn = 'yes'

-- Settings needed for .lvimrc
vim.opt.exrc = true
vim.opt.secure = true

-- Sane splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Decent wildmenu
vim.opt.wildmode = 'list:longest'
vim.opt.wildignore = '.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,.DS_Store,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor'

-- Show those damn hidden characters
-- Verbose: vim.opt.listchars = 'nbsp:¬,eol:¶,extends:»,precedes:«,trail:•'
vim.opt.listchars = 'nbsp:¬,extends:»,precedes:«,trail:•'

-- swap files.
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv('HOME') .. '/.cache/nvim/undo'
vim.opt.undofile = true

-- search settings
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.gdefault = true

-- Give more space for displaying messages.
vim.opt.cmdheight = 2

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 50

vim.opt.iskeyword:append('-')

-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append('c')

-- Wrapping options.
vim.opt.formatoptions:append('tc')  -- Wrap text and comments using textwidth
vim.opt.formatoptions:append('r')   -- Continue comments when pressing ENTER in I mode
vim.opt.formatoptions:append('q')   -- Allow formatting comments w/ gq
vim.opt.formatoptions:append('n')   -- Detect list for formatting
vim.opt.formatoptions:append('b')   -- Auto-wrap insert mode, and do not wrap old long lines


-- Plugins

-- NERDTree
vim.g.webdevicons_enable_nerdtree = 1
