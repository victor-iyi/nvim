" =============================================================================
" =============================================================================
" # Let
" =============================================================================
" =============================================================================

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
