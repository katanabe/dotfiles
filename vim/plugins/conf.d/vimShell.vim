" VimShell
" ,is: シェルを起動
nnoremap <silent> <Leader>is :VimShell<CR>
" ,ipy: pythonを非同期で起動
nnoremap <silent> <Leader>ipy :VimShellInteractive python<CR>
" ,irb: irbを非同期で起動
nnoremap <silent> <Leader>irb :VimShellInteractive irb<CR>
" ,ss: 非同期で開いたインタプリタに現在の行を評価させる
vmap <silent> <Leader>ss :VimShellSendString<CR>
" 選択中に,ss: 非同期で開いたインタプリタに選択行を評価させる
nnoremap <silent> <Leader>ss <S-v>:VimShellSendString<CR>

