" File: ~/.config/nvim/init.vim
"
" Author: Victor I. Afolabi

syntax enable

colorscheme desert
" highlight Normal guibg=none

" =============================================================================
" =============================================================================
" # PLUGINS
" =============================================================================
" =============================================================================
" Vim Plug
" Specify a directory for plugins
"   - For Neovim: stdpath('data') . '/plugged'
"   - Avoid using standard vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Load plugins
" VIM enhancements
Plug 'ciaranm/securemodelines'
Plug 'editorconfig/editorconfig-vim'
Plug 'justinmk/vim-sneak'

" GUI enhancements
Plug 'itchyny/lightline.vim'
Plug 'machakann/vim-highlightedyank'
Plug 'andymass/vim-matchup'

" NERDTree
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" Fuzzy finder
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Semantic language support
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/mycomment.vim'
Plug 'sansyrox/vim-python-virtualenv'

" Language client
if has('nvim')
  Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': './install.sh' }
end

" Syntactic language support
Plug 'cespare/vim-toml'
Plug 'stephpy/vim-yaml'
Plug 'rust-lang/rust.vim'
Plug 'rhysd/vim-clang-format'
Plug 'fatih/vim-go' 
Plug 'dag/vim-fish'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'kevinoid/vim-jsonc'

" ThePrimeagen
Plug 'jremmen/vim-ripgrep'
Plug 'tpope/vim-fugitive'
Plug 'vim-utils/vim-man'
Plug 'lyuts/vim-rtags'
Plug 'git@github.com:kien/ctrlp.vim.git'
Plug 'mbbill/undotree'

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
if has('nvim')
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzy-native.nvim'
end

call plug#end()

if has('nvim')
  set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor
  set inccommand=nosplit
  noremap <C-q> :confirm qall<CR>
end

" See https://github.com/junegunn/vim-plug for more info
"
" PlugInstall [name ...]          - Install plugins
" PlugUpdate  [name ...]          - Install or update plugins
" PlugClean   [!]                 - Remove unlisted plugins
" PlugUpgrade                     - Upgrade vim-plug itself
" PlugStatus                      - Check the status of plugins
" PlugDiff                        - Examine changes from previous update
" and pending changes
" PlugSnapshot  [!] [output path] - Generate script for restoring current
" snapshot of the plugins.


" =============================================================================
" =============================================================================
" # Editor settings
" =============================================================================
" =============================================================================
filetype plugin indent on
set timeoutlen=300          " http://stackoverflow.com/questions/2158516/delay-before-o-opens-a-new-line
set encoding=utf-8
set scrolloff=8
set noshowmode
set hidden
set nowrap
set nojoinspaces

set printfont=:h10
set printencoding=utf-8
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
set guifont=Cascadia_Code:h11
" set guifont=FiraCode_Nerd_Font:h11
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


" =============================================================================
" =============================================================================
" # Let
" =============================================================================
" =============================================================================
"
"
" Button used for `<leader>`.
let mapleader = "\<Space>"

" Markdown
let g:sneak#s_next = 1
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_frontmatter = 1

" netrw
let g:netrw_browse_split=2
let g:netrw_banner = 0
let g:netrw_winsize = 25

" ctrlp
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
let g:ctrlp_use_caching = 0

" Airline
" let g:airline_powerline_fonts = 1

" Server commands.
"
" rust - L.S. can be changed to use 'stable' | 'beta' | 'nightly'
"
let g:LanguageClient_serverCommands = {
    \ 'rust': ['~/.cargo/bin/rustup', 'run', 'stable', 'rls'],
    \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
    \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
    \ 'python': ['/Library/Frameworks/Python.framework/Versions/3.8/bin/pyls'],
    \ }

" NOTE: If you're using Plug mapping, you shouldn't use `noremap` mappings.
"
" nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
" nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
" nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>


" Plugin settings
let g:secure_modelines_allowed_items = [
                \ "textwidth",   "tw",
                \ "softtabstop", "sts",
                \ "shiftwidth",  "sw",
                \ "expandtab",   "et",  "noexpandtab", "noet",
                \ "filetype",    "ft",
                \ "foldmethod",  "fdm",
                \ "readonly",    "ro",  "noreadonly",  "noro",
                \ "rightleft",   "rl",  "norightleft", "norl",
                \ "colorcolumn"
                \ ]

" Lightline
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'filename':  'LightlineFilename',
      \   'cocstatus': 'coc#status'
      \ },
      \ }

function! LightlineFilename()
  return expand('%:t') !=# '' ? @% : '[No Name]'
endfunction

" use autocmd to force lightline update
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

" from http://sheerun.net/2014/03/21/how-to-boost-your-vim-productivity/
if executable('ag')
  set grepprg=ag\ --nogroup\ --nocolor
endif
if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep
  set grepformat=%f:%l:%c:%m
endif

" JavaScript
let javascript_fold=0

" Java
let java_ignore_javadoc=1

" Latex
let g:latex_indent_enabled = 1
let g:latex_fold_envs = 0
let g:latex_fold_sections = []

" Rust
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0
let g:rustfmt_options='--config-path ~/.config/rustfmt/rustfmt.toml'

if has('macunix')
  let g:rust_clip_command = 'pbcopy'
elseif has('win32')
  let g:rust_clip_command = 'clip'
else
  let g:rust_clip_command = 'xclip -selection clipboard'
endif

" Python
let g:python3_host_prog='/usr/local/bin/python3'

" Don't confirm .lvimrc
let g:localvimrc_ask = 0



" =============================================================================
" =============================================================================
" # Keyboard shortcuts | Mappings
" =============================================================================
" =============================================================================
" See https://stackoverflow.com/questions/3776117/what-is-the-difference-between-the-remap-noremap-nnoremap-and-vnoremap-mapping
" for more info on `nnoremap`.

" Source ~/.config/nvim/init.vim
map <C-s> :source ~/.config/nvim/init.vim<CR>

" Search result centered please
nnoremap <silent> n nzz
nnoremap <silent> N Nzz
nnoremap <silent> * *zz
nnoremap <silent> # #zz
nnoremap <silent> g* g*zz

" Very magic by default
nnoremap ? ?\v
nnoremap / /\v
cnoremap %s/ %sm/ 

" Open hotkeys
map <C-p> :Files<CR>
nmap <leader>; :Buffers<CR>

" Quick-save
nmap <leader>w :w<CR>

" ; as :
nnoremap ; :

" Ctrl+j and Ctrl+k as Esc
" Ctrl-j is a little awkward unfortunately:
" https://github.com/neovim/neovim/issues/5916
" So we also map Ctrl+k
nnoremap <C-j> <Esc>
inoremap <C-j> <Esc>
vnoremap <C-j> <Esc>
snoremap <C-j> <Esc>
xnoremap <C-j> <Esc>
cnoremap <C-j> <C-c>
onoremap <C-j> <Esc>
lnoremap <C-j> <Esc>
tnoremap <C-j> <Esc>

nnoremap <C-k> <Esc>
inoremap <C-k> <Esc>
vnoremap <C-k> <Esc>
snoremap <C-k> <Esc>
xnoremap <C-k> <Esc>
cnoremap <C-k> <C-c>
onoremap <C-k> <Esc>
lnoremap <C-k> <Esc>
tnoremap <C-k> <Esc>

" Ctrl+h to stop searching
vnoremap <C-h> :nohlsearch<cr>
nnoremap <C-h> :nohlsearch<cr>

" Suspend with Ctrl+f
inoremap <C-f> :sus<cr>
vnoremap <C-f> :sus<cr>
nnoremap <C-f> :sus<cr>


" =============================================================================
" Window Mappings.
" =============================================================================
" Window command (focus)
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>

" Window resize
nnoremap <silent> <Leader>+ :vertical resize +5<CR>
nnoremap <silent> <Leader>- :vertical resize -5<CR>
nnoremap <silent> <Leader>vr :vertical resize 30<CR>

" Move selected lines up or down.
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Project history tree.
nnoremap <leader>u :UndotreeShow<CR>
" project view (project file tree)
" nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>

""NERDTree
noremap <leader>s :Rg
let g:fzf_layout = { 'down': '~20%' }
command! -bang -nargs=* Rg
nnoremap <Leader>pt :NERDTreeToggle<Enter>
nnoremap <silent> <Leader>pv :NERDTreeFind<CR>
nnoremap <leader>n :NERDTreeFocus<CR>

""
" =============================================================================
" Editor Mappings.
" =============================================================================
vmap <Leader>y "+y
vmap <Leader>= <C-W><C-=>

" Jump to the start and end of line using the home  row keys
map H ^
map L $

" Neat X clipboard integration
" ,p will paste clipboard into buffer
" ,c will copy entire buffer into clipboard
" noremap <leader>p :read !xsel --clipboard --output<cr>
" noremap <leader>c :w !xsel -ib<cr><cr>
if has('macunix')
  noremap <leader>p :read !pbpaste<cr>
  " noremap <leader>c :w !pbcopy<cr><cr>
else
  noremap <leader>p :read !xsel --clipboard --output<cr>
  " noremap <leader>c :w !xsel -ib<cr><cr>
endif

" project search (search entire project for ...)
" <leader>s for Rg search
noremap <leader>s :Rg<SPACE>
let g:fzf_layout = { 'down': '~20%' }
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)

function! s:list_cmd()
  let base = fnamemodify(expand('%'), ':h:.:S')
  return base == '.' ? 'fd --type file --follow' : printf('fd --type file --follow | proximity-sort %s', shellescape(expand('%')))
endfunction

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, {'source': s:list_cmd(),
  \                               'options': '--tiebreak=index'}, <bang>0)

" Open new file adjacent to current file
nnoremap <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" No arrow keys -- force yourself to use the home row hjkl
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Left and right can switch buffers
nnoremap <left> :bp<CR>
nnoremap <right> :bn<CR>

" Move by line
nnoremap j gj
nnoremap k gk

" =============================================================================
" # CoC (Conquer of Completion) - https://github.com/neoclide/coc.nvim
" =============================================================================
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 'Smart' navigation
" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-.> to trigger completion.
inoremap <silent><expr> <c-.> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
    " call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSumbol' support from the language
" server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>

" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>

" Implement methods for trait
nnoremap <silent> <space>i  :call CocActionAsync('codeAction', '', 'Implement missing members')<cr>

" Show actions available at this location
nnoremap <silent> <space>a  :CocAction<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Mapping for CoCList
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" " Show all diagnostics.
" nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" " Manage extensions.
" nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" " Show commands.
" nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" " Find symbol of current document.
" nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" " Search workspace symbols.
" nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" " Do default action for next item.
" nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" " Do default action for previous item.
" nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" " Resume latest coc list.
" nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" <leader><leader> toggles between buffers
nnoremap <leader><leader> <c-^>

" <leader>, shows/hides hidden characters
nnoremap <leader>, :set invlist<cr>

" <leader>q shows stats
nnoremap <leader>q g<c-g>

" Keymap for replacing up to next _ or -
noremap <leader>m ct+

" I can type :help on my own, thanks :)
map <F1> <Esc>
imap <F1> <Esc>

" =============================================================================
" =============================================================================
" # Autocommands
" =============================================================================
" =============================================================================

" Prevent accidental writes to buffers that shouldn't be edited
autocmd BufRead *.orig set readonly
autocmd BufRead *.pacnew set readonly

" Leave paste mode when leaving insert mode
autocmd InsertLeave * set nopaste

" Jump to last edit position on opening file
if has("autocmd")
  " https://stackoverflow.com/questions/31449496/vim-ignore-specific-file-in-autocommand
  au BufReadPost * if expand('%:p') !~# '\m/\.git/' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

autocmd FileType * set tabstop=2|set shiftwidth=2|set expandtab|set softtabstop=2

" Follow Python code style rules
au Filetype python source ~/.config/nvim/scripts/fourspaces.vim
au Filetype python set colorcolumn=79

" Help filetype detection
autocmd BufRead *.plot set filetype=gnuplot
autocmd BufRead *.md set filetype=markdown
autocmd BufRead *.lds set filetype=ld
autocmd BufRead *.tex set filetype=text
autocmd BufRead *trm set filetype=c
autocmd BufRead *.cc set filetype=cpp
autocmd BufRead *.xlsx.axlsx set filetype=ruby

" Script plugins
autocmd Filetype html,xml,xsl,php source ~/.config/nvim/scripts/closetag.vim

" =============================================================================
" # Footer
" =============================================================================

" nvim
if has('nvim')
  runtime! plugin/python_setup.vim
endif
