" vim-altr 
nmap <F3> <Plug>(altr-forward)
nmap <F2> <Plug>(altr-back)
augroup VimAltrFileType
    " ヘルプの表示
    autocmd!
    autocmd FileType ruby call altr#define('%.rb', 'spec/%_spec.rb')
    autocmd FileType cpp call altr#define('%.cpp', '%.h', '%.hpp')
augroup END

