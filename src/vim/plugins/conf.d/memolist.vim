" memolist.vim 
" qfixgrep の設定
"デフォルトで使用する外部grep
set grepprg=grep
"grepに含めたくない拡張子
let MyGrep_ExcludeReg = '[~#]$\|\.dll$\|\.exe$\|\.lnk$\|\.o$\|\.obj$\|\.pdf$\|\.xls$'
"大文字、小文字を気にせずに検索する。
let g:MyGrepDefault_Ignorecase = 1
"""
nnoremap <Leader>mn  :MemoNew<CR>
nnoremap <Leader>ml  :MemoList<CR>
nnoremap <Leader>mg  :MemoGrep<CR>
let g:memolist_path = $HOME."/VimMemo" "TODO: Dropboxに変更
let g:memolist_template_dir_path = $HOME."/VimMemo" "TODO: Dropboxに変更
" let g:memolist_vimfiler = 1
let g:memolist_qfixgrep = 1
let g:memolist_memo_suffix = "markdown"
let g:memolist_memo_date = "%Y-%m-%d %H:%M"
let g:memolist_prompt_tags = 1
let g:memolist_prompt_categories = 1
let g:memolist_unite = 1
let g:memolist_unite_source = "file_rec"
let g:memolist_unite_option = "-auto-preview -horizontal"

