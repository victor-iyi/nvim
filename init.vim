" File: ~/.config/nvim/init.vim
"
" Author: Victor I. Afolabi

syntax enable

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

" Colorschemes
Plug 'ayu-theme/ayu-vim'
Plug 'bluz71/vim-nightfly-guicolors'

" GUI enhancements
Plug 'ryanoasis/vim-devicons'
Plug 'itchyny/lightline.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'machakann/vim-highlightedyank'
Plug 'andymass/vim-matchup'
Plug 'mg979/vim-visual-multi'

" TMUX/VIM navigator
Plug 'christoomey/vim-tmux-navigator'

" NERDTree
Plug 'preservim/nerdtree'

" Fuzzy finder
Plug 'airblade/vim-rooter'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" Semantic language support
if has('nvim')
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif

Plug 'sansyrox/vim-python-virtualenv'
Plug 'luochen1990/rainbow'
Plug 'github/copilot.vim'

" Comments
" Plug 'preservim/nerdcommenter'
" Plug 'b3nj5m1n/kommentary'
" Plug 'numToStr/Comment.nvim'

Plug 'neovim/nvim-lspconfig'
if has('nvim')
  Plug 'nvim-lua/lsp_extensions.nvim'
endif

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

if has('nvim')
  Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': './install.sh' }
endif

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
if has('nvim')
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzy-native.nvim'
endif

call plug#end()

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
" Plugin default setup.
" =============================================================================

" Kommentary: b3nj5m1n/kommentary
"
" lua require('kommentary.config').use_extended_mappings()

" Comment: numToStr/Comment.nvim
"
" lua require('Comment').setup()