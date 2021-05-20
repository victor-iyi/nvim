" =============================================================================
" # Sets.
" =============================================================================
set exrc
set noerrorbells

" Tab to spaces &  indentation.
set tabstop=2 softtabstop=2
set shiftwidth=2
set expandtab
set smartindent

" Line number.
set number
set relativenumber

set nowrap
set smartcase

" No *.swp files or backup files.
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile

" Highlight as we search.
set incsearch
set nohlsearch
set hidden

set scrolloff=8
set noshowmode

" Enable mouse useage (all modes)
set mouse=a
set guicursor=

set backspace=indent,eol,start
set showcmd

set completeopt=menuone,noinsert,noselect

" Left gutter for linter & other notifications
set signcolumn=yes
" Right margin for code length.
set colorcolumn=80

" Give more space for displaying messages
set cmdheight=2

" Having longer update time (default is 4000ms or 4 secs) leads
" to noticeable delays and poor user experience.
set updatetime=50

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

