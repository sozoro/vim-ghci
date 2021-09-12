scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let g:vimghci_dir = expand('<sfile>:p:h') . '/..'

function! s:OpenGHCi()
  let l:ghci_script_path = '"' . g:vimghci_dir . '/ghci"'
  let l:ghci_option      = '-ghci-script ' . l:ghci_script_path
  split
  wincmd p
  call term_start('ghci ' . l:ghci_option, { "term_name"   : "!ghci"
                                         \ , "term_rows"   : 10
                                         \ , "term_finish" : "close"
                                         \ , "curwin"      : 1
                                         \ })
  wincmd p
  call term_sendkeys(bufnr("!ghci"),":loadAndSetPSem " . expand("%:p") . "\n")
endfunction

function! s:Previous(current,str)
  let l:line = a:current
  while l:line >= 0 && match(getline(l:line),a:str) == -1
    let l:line = l:line - 1
  endwhile
  return l:line
endfunction

function! s:Next(current,str)
  let l:line = a:current
  while l:line <= line('$') && match(getline(l:line),a:str) == -1
    let l:line = l:line + 1
  endwhile
  if l:line <= line('$')
    return l:line
  else
    return -1
  endif
endfunction

function! vimghci#MatchGHCi()
  if bufnr("!ghci") == -1
    call s:OpenGHCi()
  endif
  let l:current = line('.')
  let l:pStart = s:Previous(l:current,":{")
  let l:pEnd   = s:Previous(l:current - 1,":}")
  let l:nStart = s:Next(l:current + 1,":{")
  let l:nEnd   = s:Next(l:current,":}")
  let l:start  = l:current
  let l:end    = l:current
  if l:pStart != -1 && l:nEnd != -1
    if l:pStart > l:pEnd && (l:nStart == -1 || l:nEnd < l:nStart)
      let l:start = l:pStart
      let l:end   = l:nEnd
    endif
  endif
  while l:start <= l:end
    call term_sendkeys(bufnr("!ghci"),getline(l:start) . "\n")
    let l:start = l:start + 1
  endwhile
endfunction

function! vimghci#ReloadGHCi()
  if bufnr("!ghci") == -1
    call s:OpenGHCi()
  else
    call term_sendkeys(bufnr("!ghci"),":loadAndSetPSem " . expand("%:p") . "\n")
  endif
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
