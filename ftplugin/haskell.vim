scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

noremap <C-k> :call vimghci#MatchGHCi()<CR>
noremap <C-l> :w<CR>:call vimghci#ReloadGHCi()<CR>
imap    <C-k> <ESC>:call vimghci#MatchGHCi()<CR>i
imap    <C-l> <ESC>:w<CR>:call vimghci#ReloadGHCi()<CR>i

let &cpo = s:save_cpo
unlet s:save_cpo
