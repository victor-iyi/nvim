" File: ~/.vim/plugged/mycomment.vim
"
" Comment: (also supports toggle).
"   Normal mode: <leader>c  OR <leader>cc
"   Visual mode: <leader>c
"
" Toggle:
"   Visual mode: <leader>t

if get(g:, "comment_loaded", 0) || v:version < 704
  finish
endif
let g:comment_loaded = 1

let s:save_cpo = &cpo
set cpo&vim

" Mapping
vnoremap <silent> <leader>c :call <SID>CommentFromSelected('visual')<CR>
vnoremap <silent> <leader>t :call <SID>ToggleCommentFromSelected()<CR>
nnoremap <silent> <leader>c :<C-u>set operatorfunc=<SID>CommentFromSelected<CR>g@
nnoremap <silent> <leader>cc :<C-u>set opfunc=<SID>CommentFromSelected<Bar>exe 'normal! 'v:count1.'g@_'<CR>

let s:xmls = ['html', 'xhtml', 'xml', 'eruby', 'wxml']

function! s:ToggleCommentFromSelected()
  let line = getline('.')
  if empty(line) | return | endif
  if index(s:xmls, &ft) != -1 | return | endif
  let com_beg = get(b:, 'comment_begin', get(s:comment_begin, &ft, '#'))
  let com_end = get(b:, 'comment_end', get(s:comment_end, &ft, ''))
  let hasComment = substitute(getline('.'), s:regex, '', '')[0 : len(com_beg) - 1] ==# com_beg ? 1 : 0
  let str = s:CommentToggle(line, com_beg, com_end, hasComment, indent('.'))
  call setline('.', str)
endfunction

function! s:CommentFromSelected(type, ...) range
  let pos = getcurpos()
  let sel_save = &selection
  let &selection = "inclusive"
  if index(s:xmls, &ft) != -1 && exists('*emmet#toggleComment')
    call emmet#toggleComment()
    return
  endif
  if a:type ==# 'visual'
    let start = a:firstline
autocmd BufRead *.pacnew set readonly
    let end = a:lastline
  else
    normal! '[
    let start = line('.')
    normal! ']
    let end = line('.')
  endif
  call s:CommentLines(start, end)
  let &selection = sel_save
  call setpos('.', pos)
endfunction

" Line comments... (start of the comment)
let s:comment_begin = {
      \"c"          : "// ",
      \"cpp"        : "// ",
      \"css"        : "/*",
      \"wxss"       : "/*",
      \"scss"       : "/*",
      \"default"    : "# ",
      \"python"     : "# ",
      \"make"       : "# ",
      \"sh"         : "# ",
      \"conf"       : "# ",
      \"zsh"        : "# ",
      \"dosini"     : "# ",
      \"yaml"       : "# ",
      \"toml"       : "# ",
      \"rust"       : "// ",
      \"go"         : "// ",
      \"java"       : "// ",
      \"swift"      : "// ",
      \"json"       : "// ",
      \"jsonc"      : "// ",
      \"javascript" : "// ",
      \"typescript" : "// ",
      \"plaintex"   : "% ",
      \"tex"        : "% ",
      \"vim"        : "\" ",
      \"markdown"   : "<!--",
      \"xhtml"      : "<!--",
      \"xml"        : "<!--",
      \"wxml"       : "<!--",
      \"html"       : "<!--",
      \"eruby"      : "<!--",
      \}

" (optional)
let s:comment_end = {
      \"css"        : "*/",
      \"wxss"       : "*/",
      \"scss"       : "*/",
      \"default"    : "",
      \"xhtml"      : "-->",
      \"xml"        : "-->",
      \"wxml"       : "-->",
      \"html"       : "-->",
      \"markdown"   : "-->",
      \"eruby"      : "-->",
      \}

let s:regex = '^\s*'
function! s:CommentToggle(line, com_beg, com_end, hasComment, min)
  let indent = matchstr(a:line, s:regex)
  let sl = len(indent)
  let has = a:line[sl : len(a:com_beg) + sl - 1] ==# a:com_beg
  if a:hasComment && has
    let str = indent . a:line[len(a:com_beg) + sl : len(a:line)-len(a:com_end) - 1]
  elseif !a:hasComment
    let str = a:com_beg . a:line[a:min : ] . a:com_end
    if a:min | let str = a:line[0 : a:min - 1] . str | endif
  else
    let str = a:line
  endif
  return str
endfunction

function! s:CommentLines(start, end)
  let g:s = a:start
  let g:e = a:end
  let lines = []
  let indents = []
  let com_begin = get(b:, 'comment_begin', get(s:comment_begin, &ft, '#'))
  let com_end = get(b:, 'comment_end', get(s:comment_end, &ft, ''))
  let hasComment = substitute(getline('.'), s:regex, '', '')[0 : len(com_begin) - 1] ==# com_begin ?
          \ 1 : 0
  for lnum in range(a:start, a:end)
    call add(indents, indent(lnum))
    call add(lines, getline(lnum))
  endfor
  let min_indent = min(indents)
  if min_indent && getline(a:start)[0] =~# '\t'
    let min_indent = min_indent/&tabstop
  endif
  call map(lines, 's:CommentToggle(v:val, com_begin, com_end, hasComment, min_indent)')
  call setline(a:start, lines)
endfunction

command! -range -nargs=0 Comment :call s:CommentLines(<line1>, <line2>)

let &cpo = s:save_cpo
unlet s:save_cpo
