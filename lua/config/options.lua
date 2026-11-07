-- Editor options. Values carried over from the previous config unless noted.
local opt = vim.opt
local g = vim.g

-- nvim-tree owns directory buffers; netrw must be off before any plugin loads.
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

-- Appearance.
opt.guicursor = 'n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor'
opt.guifont = { 'CaskaydiaCove Nerd Font Mono', 'h12' }
opt.termguicolors = true
opt.background = 'dark'
opt.colorcolumn = '80'
opt.showcmd = true
opt.mouse = 'a'
opt.number = true
opt.relativenumber = true
opt.signcolumn = 'yes'
opt.cursorline = true
opt.showmode = false
opt.cmdheight = 1
opt.laststatus = 3 -- One global statusline; splits read cleaner next to tmux panes.
opt.winborder = 'rounded'
opt.pumborder = 'rounded'
opt.pumheight = 12
opt.fillchars = { eob = ' ', fold = ' ', foldopen = '\u{f078}', foldclose = '\u{f054}', foldsep = ' ' }
opt.listchars = 'nbsp:¬,extends:»,precedes:«,trail:•'
opt.smoothscroll = true
opt.splitkeep = 'screen'
opt.splitright = true
opt.splitbelow = true
opt.wrap = false
opt.breakindent = true
opt.linebreak = true
opt.scrolloff = 8
opt.sidescrolloff = 8

-- Folding is computed by treesitter but starts disabled, as before; `zi` turns it on.
opt.foldenable = false
opt.foldmethod = 'expr'
opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
opt.foldtext = ''
opt.foldlevel = 99

-- Editing.
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.expandtab = true
opt.smarttab = true
opt.smartindent = true
opt.autoindent = true
opt.backspace = 'indent,eol,start'
opt.virtualedit = 'block'
opt.iskeyword:append('-')
opt.formatoptions:append('tcrqnb')
opt.joinspaces = false
opt.confirm = true

-- Search. `gdefault` is kept: `:s/a/b/` replaces every match on the line.
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true
opt.gdefault = true
opt.inccommand = 'split'

-- Command-line completion.
opt.wildmode = 'list:longest'
opt.wildignore =
  '.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,.DS_Store,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor'
opt.completeopt = 'menu,menuone,noselect'
opt.shortmess:append('cI')

-- Files. Undo history shares the previous config's directory so it carries over.
opt.swapfile = false
opt.backup = false
opt.writebackup = false
opt.undofile = true
opt.undodir = vim.fs.joinpath(vim.env.HOME, '.cache', 'nvim', 'undo')
opt.exrc = true
opt.jumpoptions = 'view'

-- Timing.
opt.timeoutlen = 1000
opt.updatetime = 300

-- Over SSH there is no pbcopy, so yank through the terminal (works through tmux too).
if vim.env.SSH_TTY then
  g.clipboard = 'osc52'
end

-- Deferred: probing the clipboard provider costs startup time.
vim.schedule(function()
  opt.clipboard = 'unnamedplus'
end)

-- Rust's `:RustPlay` copies the playground URL with this.
g.rust_clip_command = vim.uv.os_uname().sysname == 'Darwin' and 'pbcopy' or 'xclip -selection clipboard'

-- Experimental 0.12 message UI: no more "Press ENTER" prompts; `g<` opens the pager.
pcall(function()
  require('vim._core.ui2').enable({})
end)
