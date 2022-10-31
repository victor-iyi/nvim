" =============================================================================
" =============================================================================
" # Sets.
" =============================================================================
" =============================================================================
" GUI cursor.
if has('nvim')
  set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
  set inccommand=nosplit
  noremap <C-q> :confirm qall<CR>
end

" Colorschemes.
set termguicolors
" let ayucolor = "dark"
" let ayucolor = "mirage"
" See `https://github.com/bluz71/vim-nightfly-guicolors` for more details.
colorscheme nightfly
" highlight Normal guibg=none

" =============================================================================
" =============================================================================
" # Editor settings
" =============================================================================
" =============================================================================
filetype plugin indent on
set timeoutlen=300          " http://stackoverflow.com/questions/2158516/delay-before-o-opens-a-new-line
set encoding=UTF-8
set scrolloff=8
set noshowmode
set hidden
set nowrap
set nojoinspaces

set printfont=:h10
set printencoding=UTF-8
set printoptions=paper:letter
set signcolumn=yes                          " Always show the sign column.
                                            " Otherwise it would shift the
                                            " text each time diagnostics
                                            " appear/become resolved.

" Settings needed for .lvimrc
set exrc
set secure

" Sane splits
set splitright
set splitbelow

" No backup & swp files.
set noswapfile
set nobackup
set nowritebackup

" Permanent undo
set undodir=~/.vim/undodir
set undofile

" Decent wildmenu
set wildmode=list:longest
set wildignore=.hg,.svn,*~,*.png,*.jpg,*.gif,*.settings,Thumbs.db,.DS_Store,*.min.js,*.swp,publish/*,intermediate/*,*.o,*.hi,Zend,vendor

" Use narrow tabs
set shiftwidth=2              " Indentation.
set softtabstop=2             " Amount of tabuation to add when <TAB> is pressed.
set tabstop=2                 " Uses tabs as spaces.
set expandtab
set autoindent
set smarttab

" Wrapping options
set formatoptions=tc          " Wrap text and comments using textwidth
set formatoptions+=r          " continue comments when pressing ENTER in I mode
set formatoptions+=q          " enable formatting of comments with gq
set formatoptions+=n          " detect list for formatting
set formatoptions+=b          " auto-wrap insert mode, and do not wrap old long lines

" Proper search
set incsearch
set ignorecase
set smartcase
set gdefault

" =============================================================================
" =============================================================================
" # GUI settings
" =============================================================================
" =============================================================================
set guifont=CaskaydiaCove_Nerd_Font:h11
" set guifont=Victor\ Mono:h11
" set guifont=FiraCode\ Nerd\ Font:h11
set guioptions-=T             " Remove toolbar
set vb t_vb=                  " No more beeps
set backspace=indent,eol,start 
set nofoldenable
set ttyfast
" https://github.com/vim/vim/issues/1735#issuescomment-383353563
set lazyredraw
set synmaxcol=500
set laststatus=2
set relativenumber                " Relative line numbers
set number                        " Also show current absolute line

"set diffopt+=iwhite               " No whitespace in vimdiff
" Make diffing better: https://vimways.org/2018/the-power-of-diff/
"set diffopt+=algorithm:patience
"set diffopt+=indent-heuristic
set colorcolumn=80                " and give me a colored column
set showcmd                       " Show (partial) command in status line.
set mouse=a                       " Enable mouse usage (all modes) in terminals
set shortmess+=c                  " Don't give |ins-completion-menu| messages.

" Show those damn hidden characters
" Verbose: set listchars=nbsp:¬,eol:¶,extends:»,precedes:«,trail:•
set listchars=nbsp:¬,extends:»,precedes:«,trail:•

" LanguageClient server commands.
" 
" Required for operations modifying multiple buffers like rename.
set hidden

" Completion
" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

