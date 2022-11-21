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
let g:airline_powerline_fonts = 1
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_airline_statusline = 1

" Multi-cursor
" SEE: https://github.com/terryma/vim-multiple-cursors
" let g:multi_cursor_use_default_mapping = 0

" Default mapping.
" let g:multi_cursor_start_word_key       = '<C-n>'
" let g:multi_cursor_select_all_word_key  = '<A-n>'
" let g:multi_cursor_start_key            = 'g<C-n>'
" let g:multi_cursor_select_all_key       = 'g<A-n>'
" let g:multi_cursor_next_key             = '<C-n>'
" let g:multi_cursor_prev_key             = '<C-p>'
" let g:multi_cursor_skip_key             = '<C-x>'
" let g:multi_curosr_quit_key             = '<Esc>'
"
" NOTE: Please make sure to always map something to `g:multi_cursor_quit_key`,
" otherwise, you'll have a tough time quitting from multi-cursor mode.

" Default mapping.

" Brancket pair colorizer
" https://github.com/luochen1990/rainbow
" set to 0 if you want to enable it later via :RainbowToggle
let g:rainbow_active = 1

" Server commands.
"
" rust - L.S. can be changed to use 'stable' | 'beta' | 'nightly'
"
let g:LanguageClient_serverCommands = {
    \ 'rust': ['rust-analyzer'],
    \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
    \ 'javascript.jsx': ['tcp://127.0.0.1:2089'],
    \ 'python': ['/Library/Frameworks/Python.framework/Versions/3.10/bin/pyls'],
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
      \ 'colorscheme': 'nightfly',
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

" TMUX/vim navigator
let g:tmux_navigator_save_on_switch = 1  " write current buffer (but only if changed)
let g:tmux_navigator_no_mappings = 1

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
" NERDCommenter: Default Settings
" Documentation: https://github.com/preservim/nerdcommenter#settings
" =============================================================================
" Create default mappings
let g:NERDCreateDefaultMappings = 1

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not 
let g:NERDToggleCheckAllLines = 1
