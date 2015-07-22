let g:unite_enable_split_vertically = 1
let g:unite_winwidth = 50
let g:unite_enable_start_insert = 0
let g:unite_source_file_mru_ignore_pattern = '.*\/$\|.*Application\ Data.*'

" Prompt choices.
call unite#custom#profile('default', 'context', {
            \   'winheight' : 20,
            \   'prompt_direction' : 'top',
            \   'direction' : 'below',
            \   'prompt': '» ',
            \ })

" デフォルトのキーマッピング
nnoremap [unite] <Nop>
nmap     <space>u [unite]
nmap     U [unite]

" menu
" Uniteにメニューを追加できる
" TODO: 有用なものがあったらmenuにしてみる
" let g:unite_source_menu_menus = {}
" let g:unite_source_menu_menus.test3 = {
"         \     'description' : 'Test menu3',
"         \ }
" let g:unite_source_menu_menus.test3.command_candidates = [
"         \   ['ruby', 'VimShellInteractive ruby'],
"         \   ['python', 'VimShellInteractive python'],
"         \ ]
" nnoremap <silent> sm  :<C-u>Unite -horizontal menu:test3<CR>

" ソース一覧
nnoremap <silent> [unite]u :<C-u>Unite -horizontal source<CR>
" 前回のUniteをresume
nnoremap <silent> <Leader>f
            \ :<C-u>UniteResume -buffer-name=resume<CR>
" アウトライン表示
nnoremap <silent> [unite]o :<C-u>Unite -horizontal outline<CR>
" マッピング一覧
nnoremap <silent> [unite]ma :<C-u>Unite -horizontal -start-insert mapping<CR>
" grep検索
nnoremap <silent> [unite]g :<C-u>UniteWithCurrentDir 
            \ grep:. -buffer-name=search-buffer -horizontal<CR>
" カーソル位置の単語をgrep検索
nnoremap <silent> [unite]wg :<C-u>UniteWithCurrentDir
            \ grep:. -buffer-name=search-buffer<CR><C-R><C-W>
" バッファ一覧
nnoremap <C-b> :<C-u>Unite -horizontal buffer<CR>
" 最近使用したファイル
nnoremap <C-k> :<C-u>Unite
            \ -horizontal -start-insert -buffer-name=files buffer file_mru<CR>
" 新しいファイル作成など
nnoremap <C-j> :<C-u>UniteWithBufferDir
            \ -start-insert -horizontal -buffer-name=files file file/new<CR>
nnoremap <Space>w :<C-u>Unite tab -vertical -direction=topleft<CR>

augroup UniteFileType
    " ヘルプの表示
    autocmd!
    autocmd FileType vim    
                \ nnoremap <silent><buffer> K 
                \ :<C-u>Unite -start-insert -default-action=vsplit help<CR>
    autocmd FileType sh     
                \ nnoremap <silent><buffer> K 
                \ :<C-u>Unite -start-insert -default-action=vsplit ref/man<CR>
    autocmd FileType erlang 
                \ nnoremap <silent><buffer> K 
                \ :<C-u>Unite -start-insert -default-action=vsplit ref/erlang<CR>
    autocmd FileType ruby   
                \ nnoremap <silent><buffer> K
                \ :<C-u>Unite -start-insert -default-action=vsplit ref/ri<CR>
    autocmd FileType python 
                \ nnoremap <silent><buffer> K 
                \ :<C-u>Unite -start-insert -default-action=vsplit ref/pydoc<CR>
    autocmd FileType perl
                \ nnoremap <silent><buffer> K
                \ :<C-u>Unite -start-insert -default-action=vsplit ref/perldoc<CR>
    autocmd FileType unite call s:unite_my_settings()
augroup END

function! s:unite_my_settings()
    " Overwrite settings
    nmap <buffer><ESC>  <Plug>(unite_exit)
    nmap <buffer><C-c>  <Plug>(unite_exit)
    nmap <buffer><C-j>  <Plug>(unite_exit)
    imap <buffer><C-c>  <Plug>(unite_exit)
    imap <buffer><C-j>  <Plug>(unite_insert_leave)
    imap <buffer><C-w>  <Plug>(unite_delete_backward_path)
    imap <buffer><TAB>  <Plug>(unite_select_next_line)
    nmap <buffer><TAB>  <Plug>(unite_choose_action)

    nnoremap <buffer><expr>a  unite#do_action('above')
    nnoremap <buffer><expr>o  unite#do_action('left')
endfunction

let g:unite_source_grep_max_candidates = 200

" unite grep に ag(The Silver Searcher) を使う
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
  let g:unite_source_grep_max_candidates = 200
endif

